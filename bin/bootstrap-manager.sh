#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
APPLICATION_RELEASE='0.0.1'
APPLICATION_NAME='lab-manager'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SERVICE=${APPLICATION_NAME}

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/broker-persistent.yml \
    -p AMQ_USER="device1" \
    -p AMQ_PASSWORD="password" \
    -p AMQ_PROTOCOL="amqp,mqtt" \
    -p AMQ_ADDRESSES=${NAMESPACE} \
    | oc apply -n ${NAMESPACE} -f-


