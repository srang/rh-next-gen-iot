#!/usr/bin/env bash
SWAGGER_CODEGEN_VER=3.0.5
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.0:copy \
    -DoutputDirectory=${PROJ_DIR}/bin \
    -Dartifact=io.swagger.codegen.v3:swagger-codegen-cli:${SWAGGER_CODEGEN_VER}

java -Dmodels -DmodelTests=false -jar ${PROJ_DIR}/bin/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar \
    generate -l spring \
             -c ${PROJ_DIR}/data-pump/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yaml \
             -o ${PROJ_DIR}/data-pump

java -Dmodels -DmodelTests=false -jar ${PROJ_DIR}/bin/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar \
    generate -l java \
             -c ${PROJ_DIR}/data-compression/data-compression-model/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yaml \
             -o ${PROJ_DIR}/data-compression/data-compression-model
