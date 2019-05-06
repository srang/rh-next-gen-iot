#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="kafka"
APPLICATION_NAME="iot-cluster"
APPLICATION_CONTEXT_DIR="amq-streams"
OLD_NS=$(oc projects | grep '*' | awk '{ print $2 }')
oc project $NAMESPACE || oc new-project $NAMESPACE

if ! (oc get crd kafkas.kafka.strimzi.io &>/dev/null); then
    oc apply -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR} -n ${NAMESPACE}
fi
if (oc get kafka/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    oc delete kafka/${APPLICATION_NAME} -n ${NAMESPACE}
    sleep 10s
    oc delete pvc -l=strimzi.io/cluster=${APPLICATION_NAME}
fi
oc apply -f ${PROJ_DIR}/message-bridge/templates/kafka-persistent.yml -n ${NAMESPACE}
sleep 5s

timer=0
while [[ $(oc get deploy/strimzi-cluster-operator -ojsonpath='{.status.readyReplicas}' -n ${NAMESPACE}) != 1 ]] ; do
    POD_STATUS=$(oc get pods -l=name=strimzi-cluster-operator -o=jsonpath='{ range.items[*] }{ .metadata.name }{ ", status: " }{ .status.phase }{ ", restarts: " }{ range .status.containerStatuses[*] }{ .restartCount }{ end} { "\n" }{ end }' -n ${NAMESPACE})
    if [[ ${OLD_STATUS} != ${POD_STATUS} ]];  then
        echo $POD_STATUS
        OLD_STATUS=${POD_STATUS}
    fi
    RESTARTS=$(echo $POD_STATUS | awk '{ print $5 }')
    sleep 1s
    let timer=timer+1
    if [[ ${timer} -gt 200 || ${RESTARTS} -gt 3 ]]; then
        echo "${APPLICATION_NAME} failed to deploy. Timer: ${timer}, Restarts: ${RESTARTS}"
        exit -1
    fi
done

# wait for a deployments to come up
timer=0
while [[ $(oc get statefulset/${APPLICATION_NAME}-zookeeper -ojsonpath='{.status.readyReplicas}' -n ${NAMESPACE}) != 1 ]] ; do
    POD_STATUS=$(oc get pods -l=strimzi.io/cluster=${APPLICATION_NAME} -l=strimzi.io/name=${APPLICATION_NAME}-zookeeper -o=jsonpath='{ range.items[*] }{ .metadata.name }{ ", status: " }{ .status.phase }{ ", restarts: " }{ range .status.containerStatuses[*] }{ .restartCount }{ " " }{ end} { "\n" }{ end }' -n ${NAMESPACE})
    if [[ ${OLD_STATUS} != ${POD_STATUS} ]];  then
        echo $POD_STATUS
        OLD_STATUS=${POD_STATUS}
    fi
    RESTARTS=$(echo $POD_STATUS | awk '{ print $5+$6 }')
    sleep 1s
    let timer=timer+1
    if [[ $timer -gt 200 || ${RESTARTS} -gt 2 ]]; then
        echo "Zookeeper failed to deploy. Timer: ${timer}, Restarts: ${RESTARTS}"
        exit -1
    fi
done
sleep 5s
timer=0
while [[ $(oc get statefulset/${APPLICATION_NAME}-kafka -ojsonpath='{.status.readyReplicas}' -n ${NAMESPACE}) != 1 ]] ; do
    POD_STATUS=$(oc get pods -l=strimzi.io/cluster=${APPLICATION_NAME} -l=strimzi.io/name=${APPLICATION_NAME}-kafka -o=jsonpath='{ range.items[*] }{ .metadata.name }{ ", status: " }{ .status.phase }{ ", restarts: " }{ range .status.containerStatuses[*] }{ .restartCount }{ " " }{ end }{ "\n" }{ end }' -n ${NAMESPACE})
    if [[ ${OLD_STATUS} != ${POD_STATUS} ]];  then
        echo $POD_STATUS
        OLD_STATUS=${POD_STATUS}
    fi
    RESTARTS=$(echo $POD_STATUS | awk '{ print $5+$6 }')
    sleep 1s
    let timer=timer+1
    if [[ $timer -gt 200 || ${RESTARTS} -gt 2 ]]; then
        echo "Kafka failed to deploy. Timer: ${timer}, Restarts: ${RESTARTS}"
        exit -1
    fi
done
sleep 2s
timer=0
while [[ $(oc get deploy/${APPLICATION_NAME}-entity-operator -ojsonpath='{.status.readyReplicas}' -n ${NAMESPACE}) != 1 ]] ; do
    POD_STATUS=$(oc get pods -l=application=${APPLICATION_NAME}-entity-operator -o=jsonpath='{ range.items[*] }{ .metadata.name }{ ", status: " }{ .status.phase }{ ", restarts: " }{ range .status.containerStatuses[*] }{ .restartCount }{ " " }{ end} { "\n" }{ end }' -n ${NAMESPACE})
    if [[ ${OLD_STATUS} != ${POD_STATUS} ]];  then
        echo $POD_STATUS
        OLD_STATUS=${POD_STATUS}
    fi
    RESTARTS=$(echo $POD_STATUS | awk '{ print $5+$6+$7 }')
    sleep 1s
    let timer=timer+1
    if [[ ${timer} -gt 200 || ${RESTARTS} -gt 3 ]]; then
        echo "${APPLICATION_NAME} failed to deploy. Timer: ${timer}, Restarts: ${RESTARTS}"
        exit -1
    fi
done

oc apply -f ${PROJ_DIR}/message-bridge/templates/kafka-topic.yml -n ${NAMESPACE}

oc policy add-role-to-user admin user1 -n ${NAMESPACE}

oc project ${OLD_NS}
