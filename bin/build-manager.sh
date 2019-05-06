# LAB AUTHOR TESTING ONLY
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

APPLICATION_NAME="lab-manager"

java -Dmodels -DmodelTests=false -jar ${CMD_DIR}/swagger-codegen.jar \
    generate -l spring \
             -c ${PROJ_DIR}/${APPLICATION_NAME}/codegen-config.json \
             -i ${PROJ_DIR}/spec/swagger.yml \
             -o ${PROJ_DIR}/${APPLICATION_NAME}

mvn clean install -f ${PROJ_DIR}/${APPLICATION_NAME} -DskipTests
