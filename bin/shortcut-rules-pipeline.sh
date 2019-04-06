#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

APPLICATION_RELEASE='0.0.1'
SOURCE_REF='feature/rules-implementation'
SOURCE_SECRET='gitlab-source-secret'
SERVICE='data-compression'
KIE_CONTAINER='com.redhat.iot:data-compression:0.0.1-SNAPSHOT'

oc rollout pause dc/${SERVICE}-kieserver || echo "already paused"

oc process -f ${PROJ_DIR}/${SERVICE}/templates/kie-server.yml \
    -p APPLICATION_NAME=data-compression \
    -p KIE_SERVER_CONTAINER_DEPLOYMENT=datacompression=com.redhat.iot:data-compression:0.0.1-SNAPSHOT \
    -p SOURCE_REPOSITORY_URL=https://gitlab.consulting.redhat.com/ablock/iot-summit-2019.git \
    -p SOURCE_REPOSITORY_REF=feature/rules-implementation \
    -p CONTEXT_DIR=data-compression \
    -p KIE_SERVER_HTTPS_SECRET=decisioncentral-app-secret \
    -p IMAGE_STREAM_NAMESPACE=openshift | \
    oc apply -f-

oc start-build bc/${SERVICE}-kieserver --follow

#oc tag ${NAMESPACE}/${SERVICE}:latest ${NAMESPACE}/${SERVICE}:${APPLICATION_RELEASE}
#oc scale --replicas=1 dc/${SERVICE}
#oc rollout resume dc/${SERVICE}
#oc rollout latest dc/${SERVICE}
