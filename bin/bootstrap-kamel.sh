#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

KAMEL_VER="${KAMEL_VER:-0.3.2}"
NAMESPACE="${NAMESPACE:-user1}"

set -x
# install kamel client
if ! (which kamel &>/dev/null); then
    [ -f ${CMD_DIR}/kamel.tar.gz ] && rm ${CMD_DIR}/kamel.tar.gz
    curl -L -o ${CMD_DIR}/kamel.tar.gz https://github.com/apache/camel-k/releases/download/${KAMEL_VER}/camel-k-client-${KAMEL_VER}-linux-64bit.tar.gz
    tar -zxvf ${CMD_DIR}/kamel.tar.gz ./kamel
    mv ./kamel ${CMD_DIR}/
    rm ${CMD_DIR}/kamel.tar.gz
    chmod +x ${CMD_DIR}/kamel
fi

# setup cluster CRDs for kamel
if ! (oc get crd/integrations.camel.apache.org &>/dev/null); then
    ${CMD_DIR}/kamel install --cluster-setup
fi

