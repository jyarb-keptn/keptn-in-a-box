#!/bin/bash -x
    
    echo "load shipyard.yaml"
    keptn create project dynatrace --shipyard=./shipyard.yaml
    keptn add-resource --project=dynatrace --resource=./shipyard.yaml --resourceUri=shipyard.yaml
    
    keptn configure monitoring dynatrace --project=dynatrace
    
