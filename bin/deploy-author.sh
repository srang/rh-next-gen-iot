#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"

oc process -f ${PROJ_DIR}/data-compression/templates/decision-central.yml \
    -p KIE_ADMIN_USER='jboss' \
    -p KIE_ADMIN_PWD='jboss' \
    -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
    -p DECISION_CENTRAL_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-decisioncentral-openshift" \
    -p DECISION_CENTRAL_IMAGE_STREAM_TAG="${RHDM_REL}" \
    -p KIE_SERVER_IMAGE_STREAM_TAG="${RHDM_REL}" \
     | oc apply -n ${NAMESPACE} -f-