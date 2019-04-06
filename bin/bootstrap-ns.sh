#!/usr/bin/env bash
NAMESPACE="${NAMESPACE:-edge-compute}"
oc project $NAMESPACE || oc new-project $NAMESPACE
# sso used for keystore autogeneration
oc import-image openshift/sso73-openshift:1.0-7 --from=registry.access.redhat.com/redhat-sso-7/sso73-openshift --confirm -n openshift
oc import-image openshift/rhdm72-decisioncentral-openshift:1.1-2 --from=registry.access.redhat.com/rhdm-7/rhdm72-decisioncentral-openshift --confirm -n openshift
oc import-image openshift/rhdm72-kieserver-openshift:1.1-2 --from=registry.access.redhat.com/rhdm-7/rhdm72-kieserver-openshift --confirm -n openshift


if [[ -f ${PROJ_DIR}/bin/create-source-secret.secret.sh ]]; then
    if ! (oc get secret 'gitlab-source-secret' -n ${NAMESPACE}); then
        ${PROJ_DIR}/bin/create-source-secret.secret.sh
    fi
fi

if ! (oc get sa/builder -o=jsonpath='{range .secrets[*]}{ .name }{"\n"}{end}' -n ${NAMESPACE} | grep 'gitlab-source-secret' &>/dev/null); then
    echo "oc secrets link builder gitlab-source-secret -n ${NAMESPACE}"
fi

if ! (oc get svc/jenkins -n ${NAMESPACE} &> /dev/null); then
    echo "oc process openshift//jenkins-ephemeral -p=MEMORY_LIMIT=2Gi | oc apply -f- -n ${NAMESPACE}"
fi
