#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=order --image=dtdemos/dt-orders-order-service:1.0.0
sleep 30
# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=frontend --image=dtdemos/dt-orders-frontend:1.0.0
sleep 60