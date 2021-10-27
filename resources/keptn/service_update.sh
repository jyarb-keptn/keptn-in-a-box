#!/bin/bash

KEPTN_DT_SERVICE_VERSION=0.16.0
KEPTN_DT_SLI_SERVICE_VERSION=0.12.1

helm upgrade --install dynatrace-service -n keptn https://github.com/keptn-contrib/dynatrace-service/releases/download/$KEPTN_DT_SERVICE_VERSION/dynatrace-service-$KEPTN_DT_SERVICE_VERSION.tgz

kubectl -n keptn get deployment dynatrace-service -o wide
kubectl -n keptn get pods -l run=dynatrace-service

helm upgrade --install dynatrace-sli-service -n keptn https://github.com/keptn-contrib/dynatrace-sli-service/releases/download/$KEPTN_DT_SLI_SERVICE_VERSION/dynatrace-sli-service-$KEPTN_DT_SLI_SERVICE_VERSION.tgz

kubectl -n keptn get deployment dynatrace-sli-service -o wide
kubectl -n keptn get pods -l run=dynatrace-sli-service
