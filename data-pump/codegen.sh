#!/usr/bin/env bash
SWAGGER_CODEGEN_VER=3.0.4
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mvn org.apache.maven.plugins:maven-dependency-plugin:3.0.0:copy \
    -DoutputDirectory=${CMD_DIR} \
    -DdestinationFileName=swagger-codegen.jar \
    -Dartifact=io.swagger.codegen.v3:swagger-codegen-cli:${SWAGGER_CODEGEN_VER}
java -Dmodels -DmodelDocs=false -DmodelTests=false -jar ${CMD_DIR}/swagger-codegen-cli-${SWAGGER_CODEGEN_VER}.jar \
    generate -c ${CMD_DIR}/codegen-config.json -i ${CMD_DIR}/../spec/swagger.yaml -l spring
