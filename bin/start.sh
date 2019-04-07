#!/usr/bin/env bash
set -x
set -e
set -E
set -o pipefail
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export NAMESPACE='edge-compute'
export RHDM_VER='73'
export RHDM_REL="1.0-3"
export KAMEL_VER="0.3.2"

if [[ -f ${CMD_DIR}/login.secret.sh ]]; then
    ${CMD_DIR}/login.secret.sh
fi

${CMD_DIR}/bootstrap-ns.sh
${CMD_DIR}/bootstrap-kamel.sh
${CMD_DIR}/deploy-rules.sh
${CMD_DIR}/deploy-routes.sh
${CMD_DIR}/deploy-author.sh
