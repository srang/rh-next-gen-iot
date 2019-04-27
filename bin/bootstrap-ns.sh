#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"
FUSE_REL="${FUSE_REL:-1.2-12}"
AMQ_ONLINE_REL="${AMQ_ONLINE_REL:-1.0-7.1554788698}"
AMQ_BROKER_REL="${AMQ_BROKER_REL:-1.3-4}"
oc project $NAMESPACE || oc new-project $NAMESPACE

if ! (oc get istag/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc import-image rhdm-7/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} --from=registry.redhat.io/rhdm-7/rhdm73-decisioncentral-openshift --confirm -n openshift
fi
if ! (oc get istag/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc import-image rhdm-7/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} --from=registry.redhat.io/rhdm-7/rhdm73-kieserver-openshift --confirm -n openshift
fi
if ! (oc get istag/fuse7-java-openshift:${FUSE_REL} -n openshift &>/dev/null); then
    oc import-image openshift/fuse7-java-openshift:${FUSE_REL} --from=registry.redhat.io/fuse7/fuse-java-openshift --confirm -n openshift
fi
if ! (oc get istag/amq-online-1-api-server:${AMQ_ONLINE_REL} -n openshift &>/dev/null); then
    oc import-image openshift/amq-online-1-api-server:${AMQ_ONLINE_REL} --from=registry.redhat.io/amq7/amq-online-1-api-server --confirm -n openshift
    oc tag openshift/amq-online-1-api-server:${AMQ_ONLINE_REL} openshift/amq-online-1-api-server:1.0
fi
if ! (oc get istag/amq-broker-72-openshift:${AMQ_BROKER_REL} -n openshift &>/dev/null); then
    oc import-image amq-broker-7/amq-broker-72-openshift:${AMQ_BROKER_REL} --from=registry.redhat.io/amq-broker-7/amq-broker-72-openshift --confirm -n openshift
fi

#${CMD_DIR}/bootstrap-kamel.sh

