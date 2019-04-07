#!/usr/bin/env bash
set -E
set -o pipefail
set -e
CMD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="${CMD_DIR}/.."

NAMESPACE="${NAMESPACE:-edge-compute}"
RHDM_VER="${RHDM_VER:-73}"
RHDM_REL="${RHDM_REL:-1.0-3}"
oc project $NAMESPACE || oc new-project $NAMESPACE

# sso used for keystore autogeneration
oc import-image openshift/sso73-openshift:1.0-7 --from=registry.access.redhat.com/redhat-sso-7/sso73-openshift --confirm -n openshift
oc import-image openshift/rhdm${RHDM_VER}-decisioncentral-openshift:${RHDM_REL} --from=registry.access.redhat.com/rhdm-7/rhdm${RHDM_VER}-decisioncentral-openshift --confirm -n openshift
oc import-image openshift/rhdm${RHDM_VER}-kieserver-openshift:${RHDM_REL} --from=registry.access.redhat.com/rhdm-7/rhdm${RHDM_VER}-kieserver-openshift --confirm -n openshift


if [[ -f ${PROJ_DIR}/bin/create-source-secret.secret.sh ]]; then
    if ! (oc get secret 'gitlab-source-secret' -n ${NAMESPACE}); then
        ${PROJ_DIR}/bin/create-source-secret.secret.sh
    fi
fi

if ! (oc get sa/builder -o=jsonpath='{range .secrets[*]}{ .name }{"\n"}{end}' -n ${NAMESPACE} | grep 'gitlab-source-secret' &>/dev/null); then
    oc secrets link builder gitlab-source-secret -n ${NAMESPACE}
fi

${CMD_DIR}/bootstrap-kamel.sh

