#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=catalog --image=docker.io/dtdemos/dt-orders-catalog-service --tag=1.0.0

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=customer --image=docker.io/dtdemos/dt-orders-customer-service --tag=1.0.0