#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=catalog --image=dtdemos/dt-orders-catalog-service:1.0.0
sleep 30
# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=customer --image=dtdemos/dt-orders-customer-service:1.0.0
sleep 60