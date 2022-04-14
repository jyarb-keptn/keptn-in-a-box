#!/bin/bash -x
    
    keptn create project dynatrace --shipyard=./dynatrace-qg-shipyard.yaml
   
    keptn add-resource --project=dynatrace --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
