# DEPRECATED
#!/usr/bin/env bash
set -e
set -E
set -o pipefail
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export NAMESPACE='user1'
export RHDM_VER='73'
export RHDM_REL="1.0-3"
export FUSE_REL="1.2"
export KAMEL_VER="0.3.2"

${CMD_DIR}/deploy-rules.sh
${CMD_DIR}/deploy-routes.sh
${CMD_DIR}/deploy-author.sh
