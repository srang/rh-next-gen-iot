#!/usr/bin/env bash
set -E
set -o pipefail
set -e

CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE=${NAMESPACE:-edge-compute}
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"

APPLICATION_RELEASE='0.0.1'
APPLICATION_NAME='data-compression'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SOURCE_REPOSITORY_URL='https://gitlab.consulting.redhat.com/ablock/iot-summit-2019.git'
SOURCE_REPOSITORY_REF='feature/rules-implementation'
SOURCE_SECRET='gitlab-source-secret'
SERVICE='data-compression'
KIE_CONTAINER='com.redhat.iot:data-compression:0.0.1-SNAPSHOT'

if (oc get dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE}); then
    oc rollout pause dc/${APPLICATION_NAME}-kieserver || echo "already paused"
fi

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/kie-server.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
    -p KIE_SERVER_CONTAINER_DEPLOYMENT="datacompression=com.redhat.iot:data-compression:${APPLICATION_RELEASE}-SNAPSHOT" \
    -p SOURCE_REPOSITORY_URL="${SOURCE_REPOSITORY_URL}" \
    -p SOURCE_REPOSITORY_REF="${SOURCE_REPOSITORY_REF}" \
    -p CONTEXT_DIR="${APPLICATION_CONTEXT_DIR}" \
    -p KIE_SERVER_HTTPS_SECRET="${APPLICATION_NAME}-https-secret" \
    -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
    -p IMAGE_STREAM_TAG="${RHDM_REL}" \
    | oc apply -f-

# let's be thorough
oc rollout pause dc/${APPLICATION_NAME}-kieserver || echo "already paused"


build=$(oc start-build bc/${APPLICATION_NAME}-kieserver | awk '{print $1}')
while [[ $(oc get ${build} -o=jsonpath='{ .status.phase }') =~ ^(Running|Pending|New)$ ]] ; do
    # handles broken pipes (happens frequently unfortunately)
    oc logs -f ${build}
done
if [[ $(oc get ${build} -o=jsonpath='{ .status.phase }') != 'Complete' ]]; then
    echo "error with build"
    exit 1
fi

oc tag ${NAMESPACE}/${APPLICATION_NAME}-kieserver:latest ${NAMESPACE}/${APPLICATION_NAME}-kieserver:${APPLICATION_RELEASE}
oc scale --replicas=1 dc/${APPLICATION_NAME}-kieserver
oc rollout resume dc/${APPLICATION_NAME}-kieserver
oc rollout latest dc/${APPLICATION_NAME}-kieserver
