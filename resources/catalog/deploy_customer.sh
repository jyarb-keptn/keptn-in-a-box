#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=customer --image=dtdemos/dt-orders-customer-service:1.0.0