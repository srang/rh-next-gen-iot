# LAB AUTHOR TESTING ONLY
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
APPLICATION_NAME='lab-manager'

${CMD_DIR}/build-manager.sh

# For local testing, we send mqtt messages and consume amqp messgages from same port (configured in application-local.yml
BROKER_POD=$(oc get pods -l=app=broker-amq -o=jsonpath='{ range .items[0] }{.metadata.name}{end}' -n ${NAMESPACE})
MQTT_PORT=$(oc get pod/${BROKER_POD} -o=jsonpath='{.spec.containers[?(@.name=="broker-amq")].ports[?(@.name=="all")].containerPort }' -n ${NAMESPACE})
oc port-forward ${BROKER_POD} ${MQTT_PORT}:${MQTT_PORT} -n ${NAMESPACE} &
SPRING_PROFILES_ACTIVE=local java -jar ${PROJ_DIR}/${APPLICATION_NAME}/target/${APPLICATION_NAME}*.jar
