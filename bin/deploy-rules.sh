#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE=${NAMESPACE:-user1}
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"

APPLICATION_RELEASE='0.0.1'
APPLICATION_NAME='data-compression'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SOURCE_REPOSITORY_URL='https://gitlab.consulting.redhat.com/ablock/iot-summit-2019.git'
SOURCE_REPOSITORY_REF='master'
SOURCE_SECRET='gitlab-source-secret'
SERVICE='data-compression'
KIE_CONTAINER='com.redhat.iot:data-compression:0.0.1-SNAPSHOT'

if (oc get dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE}); then
    oc rollout pause dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE} || echo "already paused"
fi

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/kie-server.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
    -p KIE_SERVER_CONTAINER_DEPLOYMENT="datacompression=com.redhat.iot:data-compression:${APPLICATION_RELEASE}-SNAPSHOT" \
    -p KIE_SERVER_HTTPS_SECRET="${APPLICATION_NAME}-https-secret" \
    -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
    -p IMAGE_STREAM_TAG="${RHDM_REL}" \
    | oc apply -n ${NAMESPACE} -f-

# let's be thorough
oc rollout pause dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE} || echo "already paused"

${CMD_DIR}/build-rules.sh

build=$(oc start-build bc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE} --from-dir=${PROJ_DIR}/${APPLICATION_CONTEXT_DIR} | awk '{print $1}')
while [[ $(oc get ${build} -o=jsonpath='{ .status.phase }' -n ${NAMESPACE}) =~ ^(Running|Pending|New)$ ]] ; do
    # handles broken pipes
    oc logs -f ${build} -n ${NAMESPACE}
done
if [[ $(oc get ${build} -o=jsonpath='{ .status.phase }' -n ${NAMESPACE}) != 'Complete' ]]; then
    echo "error with build"
    exit 1
fi

oc tag ${NAMESPACE}/${APPLICATION_NAME}-kieserver:latest ${NAMESPACE}/${APPLICATION_NAME}-kieserver:${APPLICATION_RELEASE}
oc scale --replicas=1 dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE}
oc rollout resume dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE}

# TODO watch for rollout pod and tail logs
