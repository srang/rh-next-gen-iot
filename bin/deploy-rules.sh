#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."


oc process -f ${PROJ_DIR}/data-compression/rules-pipeline.yml \
     | oc apply -n ${NAMESPACE} -f-