#!/bin/bash -x

enableItemCache() {
  curl --request POST \
    --url ${UNLEASH_SERVER}/api/admin/features/ \
    --header "authorization: Basic ${UNLEASH_TOKEN}" \
    --header 'content-type: application/json' \
    --data '{
  "name": "EnableItemCache",
  "description": "carts",
  "enabled": false,
	"strategies": [
    {
      "name": "default",
      "parameters": {}
    }
  ]
}'
}

enablePromotion() {
  curl --request POST \
    --url ${UNLEASH_SERVER}/api/admin/features/ \
    --header "authorization: Basic ${UNLEASH_TOKEN}" \
    --header 'content-type: application/json' \
    --data '{
  "name": "EnablePromotion",
  "description": "carts",
  "enabled": false,
	"strategies": [
    {
      "name": "default",
      "parameters": {}
    }
  ]
}'
}

if [ $# -eq 1 ]; then
  # Read JSON and set it in the CREDS variable
  UNLEASH_SERVER=$1
  echo "Unleash Server URL has been passed: $UNLEASH_SERVER"
else
  echo "Unleash Server URL has been passed, getting it from the ConfigMap"
  DOMAIN=$(kubectl get configmap domain -n default -ojsonpath={.data.domain})
  echo "Domain: $DOMAIN"
  UNLEASH_SERVER="http://unleash.unleash-dev.$DOMAIN"
  echo "UnleashServer: $UNLEASH_SERVER"
fi

UNLEASH_TOKEN=$(echo -n keptn:keptn | base64)

enableItemCache
enablePromotion

#kubectl -n keptn create secret generic unleash --from-literal="UNLEASH_SERVER_URL=http://unleash.unleash-dev/api" --from-literal="UNLEASH_USER=keptn" --from-literal="UNLEASH_TOKEN=keptn"
# create secret with new pattern
keptn create secret unleash --scope="keptn-default" --from-literal="UNLEASH_SERVER_URL=http://unleash.unleash-dev/api" --from-literal="UNLEASH_USER=keptn" --from-literal="UNLEASH_TOKEN=keptn"

#deploy action provider
#kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/0.1.0/deploy/service.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/release-0.3.2/deploy/service.yaml -n keptn

keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation_feature_toggle.yaml --resourceUri=remediation.yaml

keptn add-resource --project=sockshop --service=carts --stage=dev --resource=remediation_feature_toggle.yaml --resourceUri=remediation.yaml

keptn add-resource --project=sockshop --stage=production --service=carts --resource=slo-self-healing-dynatrace.yaml --resourceUri=slo.yaml
