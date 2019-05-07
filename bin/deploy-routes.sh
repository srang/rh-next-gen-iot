# DEVELOPER ACTIVITY
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
APPLICATION_NAME="message-ingestion"
APPLICATION_CONTEXT_DIR="message-bridge"

## Cleanup previous release before beginning next
if (oc get integration/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    context=$(oc get integration/${APPLICATION_NAME} -o=jsonpath='{.status.context}' -n ${NAMESPACE})
    oc delete bc/camel-k-${context} -n ${NAMESPACE}
    oc delete is/camel-k-${context} -n ${NAMESPACE}
    oc delete deployment/${APPLICATION_NAME} -n ${NAMESPACE}
    oc delete integrationcontext/${context} -n ${NAMESPACE}
    oc delete integration/${APPLICATION_NAME} -n ${NAMESPACE}
fi

## Install Routes
${CMD_DIR}/kamel run ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/src/main/java/com/redhat/iot/routes/StreamsReader.java --name=${APPLICATION_NAME} -n ${NAMESPACE} \
    -d mvn:org.kie.server:kie-server-client:7.18.0.Final \
    -d camel-kafka \
    -d camel-jackson \
    -d camel-http

# Label CRs
while ! (oc get integration/${APPLICATION_NAME} -n ${NAMESPACE} -o=jsonpath='{.status.context}' &>/dev/null); do
    sleep 1s
done
oc label integration ${APPLICATION_NAME} application=${APPLICATION_NAME} -n ${NAMESPACE}
context=$(oc get integration/${APPLICATION_NAME} -o=jsonpath='{.status.context}' -n ${NAMESPACE})
while ! (oc get integrationcontext/${context} -n ${NAMESPACE} &>/dev/null); do
    sleep 1s
done
oc label integrationcontext/${context} application=${APPLICATION_NAME} -n ${NAMESPACE}

# Label build resources
while ! (oc get bc/camel-k-${context} -n ${NAMESPACE} &>/dev/null); do
    sleep 1s
done
oc label bc/camel-k-${context} application=${APPLICATION_NAME} -n ${NAMESPACE}
oc label is/camel-k-${context} application=${APPLICATION_NAME} -n ${NAMESPACE}

# Log build
while ! (oc get build -l=buildconfig=camel-k-${context} -n ${NAMESPACE} &>/dev/null); do
    sleep 1s
done
build=$(oc get build -l=buildconfig=camel-k-${context} -o=jsonpath='{range .items[*]}{.metadata.name}{end}' -n ${NAMESPACE})
while [[ $(oc get build/${build} -o=jsonpath='{ .status.phase }' -n ${NAMESPACE}) =~ ^(Running|Pending|New)$ ]] ; do
    oc logs -f build/${build} -n ${NAMESPACE}
done
if [[ $(oc get build/${build} -o=jsonpath='{ .status.phase }' -n ${NAMESPACE}) != 'Complete' ]]; then
    echo "error with build"
    exit 1
fi

# Label Deployment
while ! (oc get deployment/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); do
    sleep 1s
done
oc label deployment/${APPLICATION_NAME} application=${APPLICATION_NAME} -n ${NAMESPACE}
