#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=sockshop --service=carts-db --image=docker.io/mongo:4.2.2 --sequence=delivery-direct --labels=creator=cli
sleep 30
# Trigger the deployment
keptn trigger delivery --project=sockshop --service=carts --image=docker.io/keptnexamples/carts:0.12.1 --labels=creator=cli

