#!/bin/bash
source ../dynatrace/utils.sh

readCredsFromFile
printVariables

echo "Tenant: ${DT_TENANT}"
echo "Token: ${DT_API_TOKEN}"

KEPTN_DOMAIN=$1
AWS=$2

KEPTN_ENDPOINT=http://keptn.${KEPTN_DOMAIN}

echo "keptn endpoint: ${KEPTN_ENDPOINT}"

export DT_TENANT=$DT_TENANT
export DT_API_TOKEN=$DT_API_TOKEN
export DT_PAAS_TOKEN=$DT_PAAS_TOKEN
export KEPTN_DOMAIN=${KEPTN_DOMAIN}
export KEPTN_API_URL=${KEPTN_ENDPOINT}
export KEPTN_BRIDGE_URL=${KEPTN_ENDPOINT}/bridge

if [ "$AWS" = true ]; then
echo "export DT_TENANT=$DT_TENANT" >> ~/.bash_profile && \
echo "export DT_API_TOKEN=$DT_API_TOKEN" >> ~/.bash_profile && \
echo "export DT_PAAS_TOKEN=$DT_PAAS_TOKEN" >> ~/.bash_profile && \
echo "export KEPTN_DOMAIN=${KEPTN_DOMAIN}" >> ~/.bash_profile && \
echo "export KEPTN_API_URL=${KEPTN_ENDPOINT}" >> ~/.bash_profile && \
echo "export KEPTN_BRIDGE_URL=${KEPTN_ENDPOINT}/bridge" >> ~/.bash_profile && \
source ~/.bash_profile
fi