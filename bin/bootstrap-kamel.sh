#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-edge-compute}"

# setup cluster CRDs for kamel
if ! (oc get crd/integrations.camel.apache.org &>/dev/null); then
    ${CMD_DIR}/kamel install --cluster-setup
fi

# deploy operator in namespace
if ! (oc get deploy/camel-k-operator -n ${NAMESPACE} &>/dev/null); then
    ${CMD_DIR}/kamel install --skip-cluster-setup -n ${NAMESPACE}
fi