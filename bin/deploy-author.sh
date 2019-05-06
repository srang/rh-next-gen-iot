#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"
APPLICATION_NAME="rules-manager"
CONTEXT_DIR="data-alerting"
KIE_ADMIN_USER='jboss'
KIE_ADMIN_PWD='jboss'
KIE_USER='kieserver'
KIE_PWD='kieserver1!'

if (oc get dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE} &>/dev/null); then
    # Reprocess template to delete everything
    oc process -f ${PROJ_DIR}/${CONTEXT_DIR}/templates/authoring.yml \
        -p APPLICATION_NAME=${APPLICATION_NAME} \
        -p KIE_ADMIN_USER="${KIE_ADMIN_USER}" \
        -p KIE_ADMIN_PWD="${KIE_ADMIN_PWD}" \
        -p KIE_SERVER_CONTROLLER_USER="${KIE_USER}" \
        -p KIE_SERVER_CONTROLLER_PWD="${KIE_PWD}" \
        -p KIE_SERVER_USER="${KIE_USER}" \
        -p KIE_SERVER_PWD="${KIE_PWD}" \
        -p DECISION_CENTRAL_HTTPS_SECRET="decisioncentral-${APPLICATION_NAME}-secret" \
        -p KIE_SERVER_HTTPS_SECRET="decisioncentral-${APPLICATION_NAME}-secret" \
        -p MAVEN_REPO_USERNAME="${KIE_ADMIN_USER}" \
        -p MAVEN_REPO_PASSWORD="${KIE_ADMIN_PWD}" \
        -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
        -p IMAGE_STREAM_TAG="${RHDM_REL}" \
        -p IMAGE_STREAM_NAMESPACE='openshift' \
         | oc delete -n ${NAMESPACE} -f-
fi

oc process -f ${PROJ_DIR}/${CONTEXT_DIR}/templates/authoring.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p KIE_ADMIN_USER="${KIE_ADMIN_USER}" \
    -p KIE_ADMIN_PWD="${KIE_ADMIN_PWD}" \
    -p KIE_SERVER_CONTROLLER_USER="${KIE_USER}" \
    -p KIE_SERVER_CONTROLLER_PWD="${KIE_PWD}" \
    -p KIE_SERVER_USER="${KIE_USER}" \
    -p KIE_SERVER_PWD="${KIE_PWD}" \
    -p DECISION_CENTRAL_HTTPS_SECRET="decisioncentral-${APPLICATION_NAME}-secret" \
    -p KIE_SERVER_HTTPS_SECRET="decisioncentral-${APPLICATION_NAME}-secret" \
    -p MAVEN_REPO_USERNAME="${KIE_ADMIN_USER}" \
    -p MAVEN_REPO_PASSWORD="${KIE_ADMIN_PWD}" \
    -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
    -p IMAGE_STREAM_TAG="${RHDM_REL}" \
    -p IMAGE_STREAM_NAMESPACE='openshift' \
     | oc apply -n ${NAMESPACE} -f-
