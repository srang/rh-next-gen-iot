# DEPRECATED
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

MESSAGING_NAMESPACE="${MESSAGING_NAMESPACE:-messaging}"
CONTEXT_DIR=amq-online

oc apply -f ${PROJ_DIR}/${CONTEXT_DIR}/install
