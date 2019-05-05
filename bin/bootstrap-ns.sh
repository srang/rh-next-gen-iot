#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"
AMQ_REL="${AMQ_REL:-1.3-5}"
KAFKA_REL="${KAFKA_REL:-1.1.0}"
oc project $NAMESPACE || oc new-project $NAMESPACE

# import decision manager imagestreams
if ! (oc get istag/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc import-image rhdm-7/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} --from=registry.redhat.io/rhdm-7/rhdm73-decisioncentral-openshift --confirm -n openshift
fi
if ! (oc get istag/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc import-image rhdm-7/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} --from=registry.redhat.io/rhdm-7/rhdm73-kieserver-openshift --confirm -n openshift
fi

# import amq-broker imagestream
if ! (oc get istag/amq-broker-72-openshift:${AMQ_REL} -n openshift &>/dev/null); then
    oc import-image amq-broker-7/amq-broker-72-openshift:${AMQ_REL} --from=registry.redhat.io/amq-broker-7/amq-broker-72-openshift --confirm -n openshift
fi

# import amq-streams imagestreams
if ! (oc get istag/amq-streams-cluster-operator:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-cluster-operator:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-cluster-operator --confirm -n openshift
fi
if ! (oc get istag/amq-streams-zookeeper:${KAFKA_REL}-kafka-2.1.1 -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-zookeeper:${KAFKA_REL}-kafka-2.1.1 --from=registry.redhat.io/amq7/amq-streams-zookeeper --confirm -n openshift
fi
if ! (oc get istag/amq-streams-kafka:${KAFKA_REL}-kafka-2.1.1 -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-kafka:${KAFKA_REL}-kafka-2.1.1 --from=registry.redhat.io/amq7/amq-streams-kafka --confirm -n openshift
fi
if ! (oc get istag/amq-streams-kafka-init:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-kafka-init:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-kafka-init --confirm -n openshift
fi
if ! (oc get istag/amq-streams-zookeeper-stunnel:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-zookeeper-stunnel:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-zookeeper-stunnel --confirm -n openshift
fi
if ! (oc get istag/amq-streams-kafka-stunnel:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-kafka-stunnel:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-kafka-stunnel --confirm -n openshift
fi
if ! (oc get istag/amq-streams-entity-operator-stunnel:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-entity-operator-stunnel:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-entity-operator-stunnel --confirm -n openshift
fi
if ! (oc get istag/amq-streams-topic-operator:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-topic-operator:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-topic-operator --confirm -n openshift
fi
if ! (oc get istag/amq-streams-user-operator:${KAFKA_REL} -n openshift &>/dev/null); then
    oc import-image amq7/amq-streams-user-operator:${KAFKA_REL} --from=registry.redhat.io/amq7/amq-streams-user-operator --confirm -n openshift
fi
