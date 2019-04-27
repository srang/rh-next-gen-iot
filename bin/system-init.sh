#!/usr/bin/env bash
set -e
set -E
set -o pipefail
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export NAMESPACE='user1'
export RHDM_VER='73'
export RHDM_REL="1.0-3"
export KAMEL_VER="0.3.2"

# init cluster resources
${CMD_DIR}/bootstrap-ns.sh
${CMD_DIR}/bootstrap-kamel.sh
${CMD_DIR}/bootstrap-manager.sh

# seed dependencies on developer machines
${CMD_DIR}/bootstrap-codegen.sh
${CMD_DIR}/build-manager.sh
${CMD_DIR}/build-rules.sh
${CMD_DIR}/build-bridge.sh