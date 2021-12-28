#!/bin/bash -x
    
    echo "load shipyard.yaml"
    keptn create project dynatrace --shipyard=./dynatrace-qg-shipyard.yaml
    keptn add-resource --project=dynatrace --resource=./dynatrace-qg-shipyard.yaml --resourceUri=shipyard.yaml

    keptn configure monitoring dynatrace --project=dynatrace
    
    keptn add-resource --project=dynatrace --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml

    keptn add-resource --project=dynatrace --stage=quality-gate --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
