#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=order --image=docker.io/dtdemos/dt-orders-order-service:1.0.0

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=frontend --image=docker.io/dtdemos/dt-orders-frontend:1.0.0
