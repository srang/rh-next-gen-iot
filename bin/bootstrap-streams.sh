#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="kafka"
APPLICATION_CONTEXT_DIR="amq-streams"
OLD_NS=$(oc projects | grep '*' | awk '{ print $2 }')
oc project $NAMESPACE || oc new-project $NAMESPACE

oc apply -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR} -n ${NAMESPACE}

oc project ${OLD_NS}

