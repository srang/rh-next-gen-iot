#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
oc process -f ${WORKSPACE}/iot-cloud-monitoring/manifests/rhdm72-authoring-cert-autoconfig.yaml \
    -p KIE_ADMIN_USER='jboss' \
    -p KIE_ADMIN_PWD='jboss' \
     | oc apply -n ${NAMESPACE} -f-