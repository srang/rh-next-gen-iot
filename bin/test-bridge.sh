# LAB AUTHOR TESTING ONLY
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
APPLICATION_NAME='message-bridge'
RULES_NAME='rules-manager'

mvn clean install -f ${PROJ_DIR}/${APPLICATION_NAME} -DskipTests

BROKER_POD=$(oc get pods -l=app=broker-amq -o=jsonpath='{ range .items[0] }{.metadata.name}{end}' -n ${NAMESPACE})
MESSAGE_PORT=$(oc get pod/${BROKER_POD} -o=jsonpath='{.spec.containers[?(@.name=="broker-amq")].ports[?(@.name=="all")].containerPort }' -n ${NAMESPACE})
RULES_POD=$(oc get pods -l=service="${RULES_NAME}-kieserver" -o=jsonpath='{ range .items[0] }{.metadata.name}{end}' -n ${NAMESPACE})
RULES_PORT=$(oc get pod/${RULES_POD} -o=jsonpath='{.spec.containers[*].ports[?(@.name=="http")].containerPort }' -n ${NAMESPACE})
oc port-forward ${BROKER_POD} ${MESSAGE_PORT}:${MESSAGE_PORT} -n ${NAMESPACE} &
oc port-forward ${RULES_POD} ${RULES_PORT}:${RULES_PORT} -n ${NAMESPACE} &

SPRING_PROFILES_ACTIVE=local java -jar ${PROJ_DIR}/${APPLICATION_NAME}/target/${APPLICATION_NAME}*.jar
