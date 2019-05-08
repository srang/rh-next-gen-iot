# DEVELOPER ACTIVITY
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

SWAGGER_CODEGEN_VER=3.0.5

if [ ! -f ${CMD_DIR}/swagger-codegen.jar ]; then
    wget -O ${CMD_DIR}/swagger-codegen.jar http://central.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/${SWAGGER_CODEGEN_VER}/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar
fi
