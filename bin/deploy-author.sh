#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
oc process -f ${CMD_DIR}/../manifests/rhdm72-authoring-cert-autoconfig.yaml \
    -p KIE_ADMIN_USER='jboss' \
    -p KIE_ADMIN_PWD='jboss' \
     | oc apply -n ${NAMESPACE} -f-