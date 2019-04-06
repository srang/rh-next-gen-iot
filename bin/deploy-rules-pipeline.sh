#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"

if ! (oc get svc/jenkins -n ${NAMESPACE} &> /dev/null); then
    echo "oc process openshift//jenkins-ephemeral -p=MEMORY_LIMIT=2Gi | oc apply -f- -n ${NAMESPACE}"
fi

oc process -f ${PROJ_DIR}/data-compression/rules-pipeline.yml \
     | oc apply -n ${NAMESPACE} -f-