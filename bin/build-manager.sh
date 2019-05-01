#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

APPLICATION_NAME="lab-manager"

if [ -d ${PROJ_DIR}/${APPLICATION_NAME}/src/main/resources/static ]; then
    rm -rf ${PROJ_DIR}/${APPLICATION_NAME}/src/main/resources/static
fi

java -Dmodels -DmodelTests=false -jar ${CMD_DIR}/swagger-codegen.jar \
    generate -l spring \
             -c ${PROJ_DIR}/${APPLICATION_NAME}/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yml \
             -o ${PROJ_DIR}/${APPLICATION_NAME}

npm run build --prefix ${PROJ_DIR}/${APPLICATION_NAME}/app
mvn clean install -f ${PROJ_DIR}/${APPLICATION_NAME}
