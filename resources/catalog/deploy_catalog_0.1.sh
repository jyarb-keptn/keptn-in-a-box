#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=catalog-service --image=docker.io/dtdemos/dt-orders-catalog-service --tag=1

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=customer-service --image=docker.io/dtdemos/dt-orders-customer-service --tag=1