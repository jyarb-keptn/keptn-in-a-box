#!/bin/bash

DYNATRACE_TENANT=https://${DT_TENANT}
DYNATRACE_ENDPOINT=${DYNATRACE_TENANT}/api/config/v1/dashboards
DYNATRACE_TOKEN=${DT_API_TOKEN}

echo "DYNATRACE_ENDPOINT: ${DYNATRACE_ENDPOINT}"
echo "DYNATRACE_TOKEN: ${DYNATRACE_TOKEN}"

KEPTN_ENDPOINT=http://keptn.${KEPTN_DOMAIN}
KEPTN_PROJECT=sockshop
KEPTN_SERVICE=carts
KEPTN_STAGE=staging
KEPTN_BRIDGE_PROJECT=${KEPTN_ENDPOINT}/bridge/project/${KEPTN_PROJECT}

echo "KEPTN_ENDPOINT: ${KEPTN_ENDPOINT}"

export DYNATRACE_TENANT=${DYNATRACE_TENANT}
export DYNATRACE_ENDPOINT=${DYNATRACE_TENANT}/api/config/v1/dashboards
export DYNATRACE_TOKEN=${DYNATRACE_TOKEN}

export KEPTN_ENDPOINT=${KEPTN_ENDPOINT}
export KEPTN_PROJECT=${KEPTN_PROJECT}
export KEPTN_SERVICE=${KEPTN_SERVICE}
export KEPTN_STAGE=${KEPTN_STAGE}
export KEPTN_BRIDGE_PROJECT=${KEPTN_ENDPOINT}/bridge/project/${KEPTN_PROJECT}

kubectl create secret generic dynatrace-credentials-keptnorders -n "keptn" --from-literal="DT_TENANT=$DYNATRACE_TENANT" --from-literal="DT_API_TOKEN=$DYNATRACE_TOKEN"

cat > dynatrace.conf.yaml << EOF
---
spec_version: '0.1.0'
dtCreds: dynatrace-credentials-keptnorders
dashboard: query

EOF

keptn add-resource --project=keptnorders --stage=staging --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
