#!/bin/bash
source ./utils.sh

export DT_API_TOKEN=$DT_API_TOKEN
export DT_PAAS_TOKEN=$DT_PAAS_TOKEN
export DT_API_URL=https://$DT_TENANT/api

echo "Convert the yaml file...."
readCredsFromFile
printVariables

cp dynakube.yaml dynakubecr.test.yaml

sed -i "s+apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api+apiUrl: $DT_API_URL+g" dynakubecr.test.yaml
sed -i "s+apiToken: domain.placeholder+apiToken:+apiToken: $DT_API_TOKEN+g" dynakubecr.test.yaml
sed -i "s+dataIngestToken: paastoken.placeholder:+dataIngestToken: $DT_PAAS_TOKEN+g" dynakubecr.test.yaml