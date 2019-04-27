#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
MESSAGING_NAMESPACE="messaging"

oc delete address,addressspace,messaginguser --all -n ${NAMESPACE}
oc project ${MESSAGING_NAMESPACE}
oc delete addressspaceplan,addressplan,brokeredinfraconfig --all -n ${MESSAGING_NAMESPACE}
oc delete -f ${PROJ_DIR}/amq-online/install
oc delete pvc,route --all -n ${MESSAGING_NAMESPACE}
oc delete cm -l=app=enmasse -n ${MESSAGING_NAMESPACE}
oc delete oauthclient -l=app=enmasse
