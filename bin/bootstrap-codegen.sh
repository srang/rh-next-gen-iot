#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

SWAGGER_CODEGEN_VER=3.0.5

mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.0:copy \
    -DoutputDirectory=${PROJ_DIR}/bin \
    -Dartifact=io.swagger.codegen.v3:swagger-codegen-cli:${SWAGGER_CODEGEN_VER}
mv ${CMD_DIR}/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar ${CMD_DIR}/swagger-codegen.jar
