#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-edge-compute}"
APPLICATION_NAME="message-ingestion"

${CMD_DIR}/kamel run ${PROJ_DIR}/${APPLICATION_NAME}/StreamsReader.java --name=${APPLICATION_NAME} -n ${NAMESPACE} \
    -d mvn:org.kie.server:kie-server-client:7.18.0.Final

oc label integration ${APPLICATION_NAME} application=${APPLICATION_NAME} -n ${NAMESPACE}
context=$(oc get integration/${APPLICATION_NAME} -o=jsonpath='{.status.context}' -n ${NAMESPACE})
oc label integrationcontext/${context} application=${APPLICATION_NAME} -n ${NAMESPACE}
oc label bc/camel-k-${context} application=${APPLICATION_NAME} -n ${NAMESPACE}
oc label is/camel-k-${context} application=${APPLICATION_NAME} -n ${NAMESPACE}
oc label deployment/${APPLICATION_NAME} application=${APPLICATION_NAME} -n ${NAMESPACE}


