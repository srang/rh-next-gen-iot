#!/usr/bin/env bash
NAMESPACE=${NAMESPACE:-edge-compute}
KEY_PASS=${KEY_PASS:-dmedgepass}
KEY_ALIAS=${KEY_ALIAS:-dmedge}
if [ -f ${WORKSPACE}/data-compression/kieserver.jks ]; then
    rm -rf ${WORKSPACE}/data-compression/kieserver.jks
fi
if oc get secret kieserver-secret -n ${NAMESPACE}; then
    oc delete secret kieserver-secret -n ${NAMESPACE}
fi

if [ -f ${WORKSPACE}/data-compression/central.jks ]; then
    rm -rf ${WORKSPACE}/data-compression/central.jks
fi
if oc get secret central-secret -n ${NAMESPACE}; then
    oc delete secret central-secret -n ${NAMESPACE}
fi

keytool -genkeypair -alias "${KEY_ALIAS}" -keyalg RSA -keystore ${WORKSPACE}/data-compression/kieserver.jks \
     --dname "CN=kieserver.apps.cluster-7aad.7aad.openshiftworkshop.com,OU=Engineering,O=openshiftworkshop.com,L=Raleigh,S=NC,C=US" \
     -keypass "${KEY_PASS}" -storepass "${KEY_PASS}"
#keytool -export -alias "${KEY_ALIAS}" -keystore ${WORKSPACE}/data-compression/kieserver.jks -file server.crt -storepass "${KEY_PASS}"

keytool -genkeypair -alias "${KEY_ALIAS}" -keyalg RSA -keystore ${WORKSPACE}/data-compression/central.jks \
     --dname "CN=central.apps.cluster-7aad.7aad.openshiftworkshop.com,OU=Engineering,O=openshiftworkshop.com,L=Raleigh,S=NC,C=US" \
     -keypass "${KEY_PASS}" -storepass "${KEY_PASS}"
#keytool -export -alias "${KEY_ALIAS}" -keystore ${WORKSPACE}/data-compression/central.jks -file server.crt -storepass "${KEY_PASS}"
#keytool -import -alias "${KEY_ALIAS}" -keystore ${WORKSPACE}/data-compression/central.jks -file server.crt -storepass "${KEY_PASS}"

mv ${WORKSPACE}/data-compression/kieserver.jks ${WORKSPACE}/data-compression/keystore.jks
oc create secret generic kieserver-secret --from-file=${WORKSPACE}/data-compression/keystore.jks -n ${NAMESPACE}
mv ${WORKSPACE}/data-compression/keystore.jks ${WORKSPACE}/data-compression/kieserver.jks

mv ${WORKSPACE}/data-compression/central.jks ${WORKSPACE}/data-compression/keystore.jks
oc create secret generic central-secret --from-file=${WORKSPACE}/data-compression/keystore.jks -n ${NAMESPACE}
mv ${WORKSPACE}/data-compression/keystore.jks ${WORKSPACE}/data-compression/central.jks
