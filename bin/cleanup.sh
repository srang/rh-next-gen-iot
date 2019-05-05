# LAB AUTHOR TESTING ONLY
#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
ROUTING_APP="message-ingestion"
RULES_APP="rules-manager"
MANAGER_APP="lab-manager"
BRIDGE_APP="message-bridge"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"
AMQ_REL="${AMQ_REL:-1.3-5}"
FUSE_REL="${FUSE_REL:-1.2}"

# cleanup routing app
APPLICATION_NAME=${ROUTING_APP}
if (oc get integration/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    context=$(oc get integration/${APPLICATION_NAME} -o=jsonpath='{.status.context}' -n ${NAMESPACE})
    oc delete bc/camel-k-${context} -n ${NAMESPACE}
    oc delete is/camel-k-${context} -n ${NAMESPACE}
    oc delete deployment/${APPLICATION_NAME} -n ${NAMESPACE}
    oc delete integrationcontext/${context} -n ${NAMESPACE}
    oc delete integration/${APPLICATION_NAME} -n ${NAMESPACE}
fi

# cleanup camel-k operator
if (oc get deployment/camel-k-operator -n ${NAMESPACE} &>/dev/null); then
    oc delete deployment/camel-k-operator -n ${NAMESPACE}
fi
if (oc get bc/camel-k-groovy -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-groovy -n ${NAMESPACE}
    oc delete is/camel-k-groovy -n ${NAMESPACE}
fi
if (oc get bc/camel-k-jvm -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-jvm -n ${NAMESPACE}
    oc delete is/camel-k-jvm -n ${NAMESPACE}
fi
if (oc get bc/camel-k-kotlin -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-kotlin -n ${NAMESPACE}
    oc delete is/camel-k-kotlin -n ${NAMESPACE}
fi
if (oc get bc/camel-k-spring-boot -n ${NAMESPACE} &>/dev/null); then
    oc delete bc/camel-k-spring-boot -n ${NAMESPACE}
    oc delete is/camel-k-spring-boot -n ${NAMESPACE}
fi

# cleanup authoring env
APPLICATION_NAME=${RULES_APP}
if (oc get dc/${APPLICATION_NAME}-kieserver -n ${NAMESPACE} &>/dev/null); then
    CONTEXT_DIR="data-alerting"
    KIE_ADMIN_USER='jboss'
    KIE_ADMIN_PWD='jboss'
    KIE_USER='kieserver'
    KIE_PWD='kieserver1!'
    # Reprocess template to delete everything
    oc process -f ${PROJ_DIR}/${CONTEXT_DIR}/templates/authoring.yml \
        -p APPLICATION_NAME=${APPLICATION_NAME} \
        -p KIE_ADMIN_USER="${KIE_ADMIN_USER}" \
        -p KIE_ADMIN_PWD="${KIE_ADMIN_PWD}" \
        -p KIE_SERVER_CONTROLLER_USER="${KIE_USER}" \
        -p KIE_SERVER_CONTROLLER_PWD="${KIE_PWD}" \
        -p KIE_SERVER_USER="${KIE_USER}" \
        -p KIE_SERVER_PWD="${KIE_PWD}" \
        -p DECISION_CENTRAL_HTTPS_SECRET="decisioncentral-${APPLICATION_NAME}-secret" \
        -p KIE_SERVER_HTTPS_SECRET="decisioncentral-${APPLICATION_NAME}-secret" \
        -p MAVEN_REPO_USERNAME="${KIE_ADMIN_USER}" \
        -p MAVEN_REPO_PASSWORD="${KIE_ADMIN_PWD}" \
        -p KIE_SERVER_IMAGE_STREAM_NAME="rhdm${RHDM_VER}-kieserver-openshift" \
        -p IMAGE_STREAM_TAG="${RHDM_REL}" \
        -p IMAGE_STREAM_NAMESPACE='openshift' \
         | oc delete -n ${NAMESPACE} -f-
fi

# cleanup message-bridge
APPLICATION_NAME=${BRIDGE_APP}
if (oc get deploy/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
    APPLICATION_RELEASE='0.0.1'
    MESSAGING_USERNAME="device1"
    MESSAGING_PASSWORD='password'
    MESSAGING_SERVICE="broker-amq-headless"
    KAFKA_BOOTSTRAP_SERVER="iot-cluster-kafka-bootstrap.kafka.svc:9092"
    MESSAGING_PORT="61616"
    KIE_SERVER="http://rules-manager-kieserver:8080/services/rest/server"
    KIE_CONTAINER="esp_rules"

    oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/${APPLICATION_NAME}.yml \
        -p APPLICATION_NAME=${APPLICATION_NAME} \
        -p APPLICATION_NAMESPACE="${NAMESPACE}" \
        -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
        -p IMAGE_STREAM_TAG="${FUSE_REL}" \
        -p MESSAGING_SERVICE="${MESSAGING_SERVICE}" \
        -p MESSAGING_PORT="${MESSAGING_PORT}" \
        -p MESSAGING_USERNAME="${MESSAGING_USERNAME}" \
        -p MESSAGING_PASSWORD="${MESSAGING_PASSWORD}" \
        -p KAFKA_BOOTSTRAP_SERVER="${KAFKA_BOOTSTRAP_SERVER}" \
        -p KIE_SERVER="${KIE_SERVER}" \
        -p KIE_CONTAINER="${KIE_CONTAINER}" \
        | oc delete -n ${NAMESPACE} -f-
fi

# cleanup lab-manager
APPLICATION_NAME=${MANAGER_APP}
if (oc get deploy/${APPLICATION_NAME} -n ${NAMESPACE} &>/dev/null); then
    APPLICATION_CONTEXT_DIR=${APPLICATION_NAME}
    APPLICATION_RELEASE='0.0.1'
    MESSAGING_USERNAME="device1"
    MESSAGING_PASSWORD='password'
    MESSAGING_SERVICE="broker-amq-headless"
    MQTT_PORT="1883"
    AMQP_PORT="61616"

    oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/${APPLICATION_NAME}.yml \
        -p APPLICATION_NAME=${APPLICATION_NAME} \
        -p APPLICATION_NAMESPACE="${NAMESPACE}" \
        -p APPLICATION_RELEASE="${APPLICATION_RELEASE}" \
        -p IMAGE_STREAM_TAG="${FUSE_REL}" \
        -p MESSAGING_SERVICE="${MESSAGING_SERVICE}" \
        -p MQTT_PORT="${MQTT_PORT}" \
        -p AMQP_PORT="${AMQP_PORT}" \
        -p MESSAGING_USERNAME="${MESSAGING_USERNAME}" \
        -p MESSAGING_PASSWORD="${MESSAGING_PASSWORD}" \
        | oc delete -n ${NAMESPACE} -f-
fi
# cleanup kafka

# cleanup amq broker
if (oc get statefulset/broker-amq -n ${NAMESPACE} &>/dev/null); then
    # Reprocess template and delete all resources
    APPLICATION_CONTEXT_DIR=${MANAGER_APP}
    oc process -f ${PROJ_DIR}/${APPLICATION_CONTEXT_DIR}/templates/broker-persistent.yml \
        -p AMQ_USER="device1" \
        -p AMQ_PASSWORD="password" \
        -p AMQ_PROTOCOL="amqp,mqtt" \
        -p AMQ_ADDRESSES=${NAMESPACE} \
        -p IMAGE_VERSION=${AMQ_REL} \
        | oc delete -n ${NAMESPACE} -f-
    # Clean up leftover PVC
    oc delete pvc -l=app=broker-amq -n ${NAMESPACE}
fi


# Wipe away imagestreams
if (oc get istag/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc delete istag rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} -n openshift
fi
if (oc get istag/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc delete istag rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} -n openshift
fi
if (oc get istag/amq-broker-72-openshift:${AMQ_REL} -n openshift &>/dev/null); then
    oc delete istag amq-broker-72-openshift:${AMQ_REL} -n openshift
fi

oc delete namespace ${NAMESPACE}
