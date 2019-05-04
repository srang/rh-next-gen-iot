#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-user1}"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"
oc project $NAMESPACE || oc new-project $NAMESPACE

# TODO Check image deploy health
if ! (oc get istag/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc import-image rhdm-7/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} --from=registry.access.redhat.com/rhdm-7/rhdm73-decisioncentral-openshift --confirm -n openshift
fi
if ! (oc get istag/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} -n openshift &>/dev/null); then
    oc import-image rhdm-7/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} --from=registry.access.redhat.com/rhdm-7/rhdm73-kieserver-openshift --confirm -n openshift
fi
