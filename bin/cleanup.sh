#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
ROUTING_APP="message-ingestion"
RULES_APP="data-compression"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"

# cleanup routing app
APPLICATION_NAME=${ROUTING_APP}
if (oc get integration/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    context=$(oc get integration/${APPLICATION_NAME} -o=jsonpath='{.status.context}' -n ${NAMESPACE})
    oc delete bc/camel-k-${context} -n ${NAMESPACE}
    oc delete is/camel-k-${context} -n ${NAMESPACE}
    oc delete deployment/${APPLICATION_NAME} -n ${NAMESPACE}
    oc delete integrationcontext/${context} -n ${NAMESPACE}
    oc delete integration/${APPLICATION_NAME} -n ${NAMESPACE}
fi

# cleanup camel-k operator
if (oc get deployment/camel-k-operator -n ${NAMESPACE} &>/dev/null); then
    oc delete deployment/camel-k-operator -n ${NAMESPACE}
fi
if (oc get bc/camel-k-groovy -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-groovy -n ${NAMESPACE}
    oc delete is/camel-k-groovy -n ${NAMESPACE}
fi
if (oc get bc/camel-k-jvm -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-jvm -n ${NAMESPACE}
    oc delete is/camel-k-jvm -n ${NAMESPACE}
fi
if (oc get bc/camel-k-kotlin -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-kotlin -n ${NAMESPACE}
    oc delete is/camel-k-kotlin -n ${NAMESPACE}
fi
if (oc get bc/camel-k-spring-boot -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-spring-boot -n ${NAMESPACE}
    oc delete is/camel-k-spring-boot -n ${NAMESPACE}
fi

# cleanup data-compression app
APPLICATION_NAME=${RULES_APP}
if (oc get dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE} &>/dev/null); then
    APPLICATION_RELEASE='0.0.1'
    APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
    SOURCE_REPOSITORY_URL='https://gitlab.consulting.redhat.com/ablock/iot-summit-2019.git'
    SOURCE_REPOSITORY_REF='master'
    SOURCE_SECRET='gitlab-source-secret'
    SERVICE='data-compression'
    KIE_CONTAINER='com.redhat.iot:data-compression:0.0.1-SNAPSHOT'
    oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/kie-server.yml \
        -p APPLICATION_NAME=${APPLICATION_NAME} \
        -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
        -p KIE_SERVER_CONTAINER_DEPLOYMENT="datacompression=com.redhat.iot:data-compression:${APPLICATION_RELEASE}-SNAPSHOT" \
        -p KIE_SERVER_HTTPS_SECRET="${APPLICATION_NAME}-https-secret" \
        -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
        -p IMAGE_STREAM_TAG="${RHDM_REL}" \
        | oc delete -n ${NAMESPACE} -f-
fi

# cleanup decision central
if (oc get dc/${APPLICATION_NAME}-rhdmcentr -n ${NAMESPACE} &>/dev/null); then
    oc process -f ${PROJ_DIR}/data-compression/templates/decision-central.yml \
        -p KIE_ADMIN_USER='jboss' \
        -p KIE_ADMIN_PWD='jboss' \
        -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
        -p DECISION_CENTRAL_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-decisioncentral-openshift" \
        -p DECISION_CENTRAL_IMAGE_STREAM_TAG="${RHDM_REL}" \
        -p KIE_SERVER_IMAGE_STREAM_TAG="${RHDM_REL}" \
        | oc delete -n ${NAMESPACE} -f-
fi