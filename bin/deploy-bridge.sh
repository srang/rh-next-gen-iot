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

if (oc get deploy/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"
fi

MESSAGING_USERNAME="device1"
MESSAGING_PASSWORD='password'
MESSAGING_SERVICE="broker-amq-headless"
KAFKA_BOOTSTRAP_SERVER="iot-cluster-kafka-bootstrap.kafka.svc:9092"
MESSAGING_PORT="61616"
KIE_SERVER="http://rules-manager-kieserver:8080/services/rest/server"
KIE_CONTAINER="esp_rules"

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

# let's be thorough
oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"

${CMD_DIR}/build-bridge.sh

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
