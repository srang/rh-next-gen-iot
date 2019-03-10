#!/usr/bin/env bash
#NAMESPACE="${NAMESPACE:-edge-compute}"
#oc new-project $NAMESPACE
oc import-image openshift/sso73-openshift:1.0-7 --from=registry.access.redhat.com/redhat-sso-7/sso73-openshift --confirm -n openshift
oc import-image openshift/rhdm72-decisioncentral-openshift:1.1-2 --from=registry.access.redhat.com/rhdm-7/rhdm72-decisioncentral-openshift --confirm -n openshift
oc import-image openshift/rhdm72-kieserver-openshift:1.1-2 --from=registry.access.redhat.com/rhdm-7/rhdm72-kieserver-openshift --confirm -n openshift
