#!/usr/bin/env bash
set -e
set -E
set -o pipefail
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export NAMESPACE='user1'
export RHDM_VER='73'
export RHDM_REL="1.0-3"
export KAMEL_VER="0.3.2"
export FUSE_REL="1.2"
export AMQ_REL="1.3-5"

# init cluster resources
# import RHDM images
${CMD_DIR}/bootstrap-ns.sh
# deploy amq broker
${CMD_DIR}/bootstrap-broker.sh
# Kamel
${CMD_DIR}/bootstrap-kamel.sh
# deploy amq streams
${CMD_DIR}/bootstrap-streams.sh
# download swagger codegen
#${CMD_DIR}/bootstrap-codegen.sh

# deploy decision manager
${CMD_DIR}/deploy-author.sh
# deploys lab manager
# depends on healthy broker
#${CMD_DIR}/deploy-manager.sh
# deploys amq-kafka bridge
# depends on amq + kafka
#${CMD_DIR}/deploy-bridge.sh

