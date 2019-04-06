#!/usr/bin/env bash
set -x
set -e
set -E
set -o pipefail
export NAMESPACE='edge-compute'
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ -f ${CMD_DIR}/login.secret.sh ]]; then
    ${CMD_DIR}/login.secret.sh
fi

${CMD_DIR}/bootstrap-ns.sh
${CMD_DIR}/deploy-rules.sh

