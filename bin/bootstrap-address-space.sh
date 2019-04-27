#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"

APPLICATION_NAME='lab-manager'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SERVICE=${APPLICATION_NAME}
MESSAGING_PASSWORD=$(echo 'password' | base64)

# errors if not present
#if ! (oc get addressspace/${NAMESPACE} -n ${NAMESPACE} &>/dev/null); then
#    oc delete addressspace/${NAMESPACE} -n ${NAMESPACE}
#fi
#if ! (oc get address/${NAMESPACE}.temperature -n ${NAMESPACE} &>/dev/null); then
#    oc delete addressspace/${NAMESPACE}.temperature -n ${NAMESPACE}
#fi

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/address-space.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_NAMESPACE="${NAMESPACE}" \
    | oc create -n ${NAMESPACE} -f-

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/address.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_NAMESPACE="${NAMESPACE}" \
    | oc create -n ${NAMESPACE} -f-

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/messaging-user.yml \
    -p APPLICATION_NAME=${APPLICATION_NAME} \
    -p APPLICATION_NAMESPACE="${NAMESPACE}" \
    -p MESSAGING_PASSWORD="${MESSAGING_PASSWORD}" \
    | oc create -n ${NAMESPACE} -f-
