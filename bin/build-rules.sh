#!/usr/bin/env bash
set -E
set -o pipefail
set -e

CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."
APPLICATION_NAME='data-compression'

${CMD_DIR}/codegen.sh
mvn clean install -f ${PROJ_DIR}/${APPLICATION_NAME}
