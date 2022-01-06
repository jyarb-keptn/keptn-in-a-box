#!/bin/bash

if [[ -z "$SLACK_TOKEN" ]]; then
  echo "Is the token set?"
  TOKEN=$1
fi

DYNATRACE_TENANT=https://${DT_TENANT}
DYNATRACE_ENDPOINT=${DYNATRACE_TENANT}/api/config/v1/dashboards
DYNATRACE_TOKEN=${DT_API_TOKEN}
TOKEN=${SLACK_TOKEN}

echo "DYNATRACE_ENDPOINT: ${DYNATRACE_ENDPOINT}"
echo "DYNATRACE_TOKEN: ${DYNATRACE_TOKEN}"

KEPTN_ENDPOINT=http://keptn.${KEPTN_DOMAIN}

echo "KEPTN_ENDPOINT: ${KEPTN_ENDPOINT}"
echo "TOKEN: ${TOKEN}"

export KEPTN_ENDPOINT=${KEPTN_ENDPOINT}

keptn create secret slack-webhook --scope="keptn-webhook-service" --from-literal="token=$TOKEN" --from-literal="bridgeUrl=$KEPTN_ENDPOINT"
