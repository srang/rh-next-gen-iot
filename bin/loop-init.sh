#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

#clusters=( "https://api.cluster-14ce.14ce.openshiftworkshop.com:6443" "https://api.cluster-f933.f933.openshiftworkshop.com:6443" "https://api.cluster-43fc.43fc.openshiftworkshop.com:6443" )
clusters=( "https://api.cluster-f933.f933.openshiftworkshop.com:6443" "https://api.cluster-43fc.43fc.openshiftworkshop.com:6443" )
for cluster in ${clusters[@]}; do
    oc login --insecure-skip-tls-verify=true $cluster -u ${USERNAME} --password ${CLUSTER_PASSWORD}
    ${CMD_DIR}/system-init.sh
    kamel install --skip-cluster-setup -n user1
    ${CMD_DIR}/deploy-manager.sh
    ${CMD_DIR}/deploy-bridge.sh
done

