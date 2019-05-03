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
MQTT_SERVICE="broker-amq-headless"
MQTT_PORT="1883"
#MESSAGING_USERNAME=$(oc get messaginguser/${NAMESPACE}.device1 -o=jsonpath='{ .spec.username }' -n ${NAMESPACE})
#MESSAGING_PASSWORD=$(echo 'password' | base64)
#MQTT_SERVICE=$(oc get addressspace/${NAMESPACE} \
#    -o=jsonpath='{ range .status.endpointStatuses[?(@.name=="mqtt")] }{ .serviceHost }{ end }' -n ${NAMESPACE})
#MQTT_PORT=$(oc get addressspace/${NAMESPACE} \
#    -o=jsonpath='{ range .status.endpointStatuses[?(@.name=="mqtt")] }{ range .servicePorts[?(@.name=="mqtt")] }{ .port }{ end }{ end }' -n ${NAMESPACE})

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/${APPLICATION_NAME}.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_NAMESPACE="${NAMESPACE}" \
    -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
    -p IMAGE_STREAM_TAG="${FUSE_REL}" \
    -p MQTT_SERVICE="${MQTT_SERVICE}" \
    -p MQTT_PORT="${MQTT_PORT}" \
    -p MESSAGING_USERNAME="${MESSAGING_USERNAME}" \
    -p MESSAGING_PASSWORD="${MESSAGING_PASSWORD}" \
    | oc apply -n ${NAMESPACE} -f-

# let's be thorough
oc rollout pause deploy/${APPLICATION_NAME} -n ${NAMESPACE} 2>/dev/null || echo "already paused"

${CMD_DIR}/build-manager.sh

#TODO check/cancel

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
