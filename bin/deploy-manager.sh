#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
FUSE_REL="${FUSE_REL:-1.2}"

APPLICATION_RELEASE='0.0.1'
APPLICATION_NAME='lab-manager'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SERVICE=${APPLICATION_NAME}

if (oc get deploy/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"
fi

MESSAGING_USERNAME="device1"
MESSAGING_PASSWORD='password'
MESSAGING_SERVICE="broker-amq-headless"
MQTT_PORT="1883"
AMQP_PORT="61616"

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/${APPLICATION_NAME}.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_NAMESPACE="${NAMESPACE}" \
    -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
    -p IMAGE_STREAM_TAG="${FUSE_REL}" \
    -p MESSAGING_SERVICE="${MESSAGING_SERVICE}" \
    -p MQTT_PORT="${MQTT_PORT}" \
    -p AMQP_PORT="${AMQP_PORT}" \
    -p MESSAGING_USERNAME="${MESSAGING_USERNAME}" \
    -p MESSAGING_PASSWORD="${MESSAGING_PASSWORD}" \
    | oc apply -n ${NAMESPACE} -f-

oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"

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
