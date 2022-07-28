#!/bin/bash

cd ~/keptn-in-a-box/resources/keptnwebservices

keptn add-resource --project=performance --service=eval --all-stages --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml

keptn add-resource --project=qualitygate --service=evalservice --all-stages --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml

keptn add-resource --project=performance --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml

keptn add-resource --project=qualitygate --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml

cd ~/keptn-in-a-box/resources/keptn

keptn add-resource --project=performance --resource=./shipyard-performance.yaml --resourceUri=shipyard.yaml