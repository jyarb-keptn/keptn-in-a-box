#!/bin/bash

DYNATRACE_TENANT=https://${DT_TENANT}
DYNATRACE_ENDPOINT=${DYNATRACE_TENANT}/api/config/v1/dashboards
DYNATRACE_TOKEN=${DT_API_TOKEN}

echo "DYNATRACE_ENDPOINT: ${DYNATRACE_ENDPOINT}"
echo "DYNATRACE_TOKEN: ${DYNATRACE_TOKEN}"

function pullID() {
  echo ""
  echo "Get Kube id..."
  echo "GET https://$DT_TENANT/api/config/v1/kubernetes/credentials"
  curl -X GET \
          "https://$DT_TENANT/api/config/v1/kubernetes/credentials" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -o kubeid.json
  cat kubeid.json
  echo ""
}

function pullConfig() {
    TOKEN_FILE=kubeid.json

    if [ -f "$TOKEN_FILE" ]; then
        echo "Reading token from file $TOKEN_FILE"
        TOKENJSON=$(cat $TOKEN_FILE)
        KUBEID=$(echo $TOKENJSON | jq -r '.values[].id')
    fi

  echo "Here is the ID: $KUBEID"
  echo "Get Kube config..."
  echo "GET https://$DT_TENANT/api/config/v1/kubernetes/credentials/$KUBEID"
  curl -X GET \
          "https://$DT_TENANT/api/config/v1/kubernetes/credentials/$KUBEID" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -o kubeconfig.json
  cat kubeconfig.json
  echo ""
}

function changeConfig() {
    TOKEN_FILE=kubeid.json
    CONFIG_FILE=kubeconfig.json

    if [ -f "$TOKEN_FILE" ]; then
        echo "Reading token from file $TOKEN_FILE"
        TOKENJSON=$(cat $TOKEN_FILE)
        KUBEID=$(echo $TOKENJSON | jq -r '.values[].id')
    fi

    if [ -f "$CONFIG_FILE" ]; then
        echo "Reading config from file $CONFIG_FILE"
        #TOKENJSON=$(cat $TOKEN_FILE)
        CONFIG=$(echo $CONFIG_FILE | jq '.eventsIntegrationEnabled = true' | \
        jq '.workloadIntegrationEnabled = true' | \
        jq '.davisEventsIntegrationEnabled = true')

    fi

    echo $CONFIG 

  echo ""
  echo "Set Kube config..."
  echo "PUT https://$DT_TENANT/api/config/v1/kubernetes/credentials/$KUBEID"
  curl -X PUT \
          "https://$DT_TENANT/api/config/v1/kubernetes/credentials/$KUBEID" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d  "$CONFIG_FILE" \
          -o kubeconfigresponse.json
  cat kubeconfigresponse.json
  echo ""
}

#perform tasks
pullID
pullConfig
changeConfig
