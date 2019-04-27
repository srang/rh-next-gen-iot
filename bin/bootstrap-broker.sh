#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
APPLICATION_RELEASE='0.0.1'
APPLICATION_NAME='lab-manager'
APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
SERVICE=${APPLICATION_NAME}

if (oc get statefulset/broker-amq -n ${NAMESPACE} &>/dev/null); then
    oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/broker-persistent.yml \
        -p AMQ_USER="device1" \
        -p AMQ_PASSWORD="password" \
        -p AMQ_PROTOCOL="amqp,mqtt" \
        -p AMQ_ADDRESSES=${NAMESPACE} \
        | oc delete -n ${NAMESPACE} -f-
    oc delete pvc -l=app=broker-amq -n ${NAMESPACE}
fi

oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/broker-persistent.yml \
    -p AMQ_USER="device1" \
    -p AMQ_PASSWORD="password" \
    -p AMQ_PROTOCOL="amqp,mqtt" \
    -p AMQ_ADDRESSES=${NAMESPACE} \
    | oc apply -n ${NAMESPACE} -f-

while [[ $(oc get statefulset/broker-amq -ojsonpath='{.status.readyReplicas}' -n ${NAMESPACE}) != 1 ]] ; do
    POD_STATUS=$(oc get pods -l=app=broker-amq -o=jsonpath='{ range.items[*] }{ .metadata.name }{ ":" }{ .status.phase }{ "\n" }{ end }' -n ${NAMESPACE})
    if [[ ${OLD_STATUS} != ${POD_STATUS} ]];  then
        echo $POD_STATUS
        OLD_STATUS=${POD_STATUS}
    fi
    sleep 1s
done
oc rsh -n ${NAMESPACE} statefulset/broker-amq /home/jboss/broker/bin/artemis address update --name ${NAMESPACE} --multicast --anycast
