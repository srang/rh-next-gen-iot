#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

SWAGGER_CODEGEN_VER=3.0.5
RULES_NAME="data-compression"
GEN_NAME="data-pump"

mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.0:copy \
    -DoutputDirectory=${PROJ_DIR}/bin \
    -Dartifact=io.swagger.codegen.v3:swagger-codegen-cli:${SWAGGER_CODEGEN_VER}

java -Dmodels -DmodelTests=false -jar ${PROJ_DIR}/bin/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar \
    generate -l spring \
             -c ${PROJ_DIR}/${GEN_NAME}/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yml \
             -o ${PROJ_DIR}/${GEN_NAME}

java -Dmodels -DmodelTests=false -jar ${PROJ_DIR}/bin/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar \
    generate -l spring \
             -c ${PROJ_DIR}/${RULES_NAME}/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yml \
             -o ${PROJ_DIR}/${RULES_NAME}
