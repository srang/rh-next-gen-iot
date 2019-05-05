#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
FUSE_REL="${FUSE_REL:-1.2}"

APPLICATION_RELEASE='0.0.1'
APPLICATION_NAME='message-bridge'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SERVICE=${APPLICATION_NAME}
MESSAGING_USERNAME="device1"
MESSAGING_PASSWORD='password'
MESSAGING_SERVICE="broker-amq-headless"
KAFKA_BOOTSTRAP_SERVER="iot-cluster-kafka-bootstrap.kafka.svc:9092"
MESSAGING_PORT="61616"
KIE_SERVER="http://rules-manager-kieserver:8080/services/rest/server"
KIE_CONTAINER="esp_rules"

if (oc get deploy/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"
fi

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/${APPLICATION_NAME}.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_NAMESPACE="${NAMESPACE}" \
    -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
    -p IMAGE_STREAM_TAG="${FUSE_REL}" \
    -p MESSAGING_SERVICE="${MESSAGING_SERVICE}" \
    -p MESSAGING_PORT="${MESSAGING_PORT}" \
    -p MESSAGING_USERNAME="${MESSAGING_USERNAME}" \
    -p MESSAGING_PASSWORD="${MESSAGING_PASSWORD}" \
    -p KAFKA_BOOTSTRAP_SERVER="${KAFKA_BOOTSTRAP_SERVER}" \
    -p KIE_SERVER="${KIE_SERVER}" \
    -p KIE_CONTAINER="${KIE_CONTAINER}" \
    | oc apply -n ${NAMESPACE} -f-

oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"

# temporarily move StreamsReader.java
STREAMS_READER_DIR=${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/src/main/java/com/redhat/iot/routes
TEMP_DIR=${PROJ_DIR}/message-ingestion
if [[ -f ${STREAMS_READER_DIR}/StreamsReader.java ]]; then
    if [[ -d ${TEMP_DIR} ]]; then
        echo "WARNING: Message bridge may have failed to cleanup properly after last deployment"
        exit -1
    fi
    mkdir ${TEMP_DIR}
    mv ${STREAMS_READER_DIR}/StreamsReader.java ${TEMP_DIR}
else
    echo "WARNING: StreamsReader not found"
fi
# cancel running builds
running_builds=$(oc get builds -l=application=${APPLICATION_NAME} -ojsonpath='{ range .items[?(.status.phase=="Running")] }{ .metadata.name }{ "\n" }{ end }' -n ${NAMESPACE})
if [[ ! -z $running_builds ]]; then
    oc cancel-build ${running_builds} -n ${NAMESPACE}
fi

java -Dmodels -DmodelTests=false -jar ${CMD_DIR}/swagger-codegen.jar \
    generate -l spring \
             -c ${PROJ_DIR}/${APPLICATION_NAME}/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yml \
             -o ${PROJ_DIR}/${APPLICATION_NAME}

build=$(oc start-build bc/${APPLICATION_NAME} -n ${NAMESPACE} --from-dir=${PROJ_DIR}/${APPLICATION_CONTEXT_DIR} | awk '{print $1}')

if [[ -f ${TEMP_DIR}/StreamsReader.java ]]; then
    mv ${TEMP_DIR}/StreamsReader.java ${STREAMS_READER_DIR}
    rmdir ${TEMP_DIR}
fi

while [[ $(oc get ${build} -o=jsonpath='{ .status.phase }' -n ${NAMESPACE}) =~ ^(Running|Pending|New)$ ]] ; do
    # handles broken pipes
    oc logs -f ${build} -n ${NAMESPACE}
done

if [[ $(oc get ${build} -o=jsonpath='{ .status.phase }' -n ${NAMESPACE}) != 'Complete' ]]; then
    echo "error with build"
    exit 1
fi


oc tag ${NAMESPACE}/${APPLICATION_NAME}:latest ${NAMESPACE}/${APPLICATION_NAME}:${APPLICATION_RELEASE}
oc scale --replicas=1 deploy/${APPLICATION_NAME} -n ${NAMESPACE}
oc rollout resume deploy/${APPLICATION_NAME} -n ${NAMESPACE}
sleep 5s

timer=0
while [[ $(oc get deploy/${APPLICATION_NAME} -ojsonpath='{.status.readyReplicas}' -n ${NAMESPACE}) != 1 ]] ; do
    POD_STATUS=$(oc get pods -l=application=${APPLICATION_NAME} -o=jsonpath='{ range.items[*] }{ .metadata.name }{ ", status: " }{ .status.phase }{ ", restarts: " }{ range .status.containerStatuses[*] }{ .restartCount }{ end} { "\n" }{ end }' -n ${NAMESPACE})
    if [[ ${OLD_STATUS} != ${POD_STATUS} ]];  then
        echo $POD_STATUS
        OLD_STATUS=${POD_STATUS}
    fi
    RESTARTS=$(echo $POD_STATUS | awk '{ print $5 }')
    sleep 1s
    let timer=timer+1
    if [[ ${timer} -gt 200 || ${RESTARTS} -gt 0 ]]; then
        echo "${APPLICATION_NAME} failed to deploy. Timer: ${timer}, Restarts: ${RESTARTS}"
        exit -1
    fi
done
