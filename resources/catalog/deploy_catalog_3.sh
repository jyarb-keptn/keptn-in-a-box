#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=catalog --image=dtdemos/dt-orders-catalog-service --tag=1.0.0

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=order --image=dtdemos/dt-orders-order-service --tag=3.0.0

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=frontend --image=dtdemos/dt-orders-frontend --tag=1.0.0

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=customer --image=dtdemos/dt-orders-customer-service --tag=3.0.0
