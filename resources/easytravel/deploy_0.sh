#!/bin/bash -x

# Trigger the deployment
keptn trigger delivery --project=easytravel --service=easytravel-mongodb --image=dynatrace/easytravel-mongodb:2.0.0.3356 --sequence=delivery-direct --labels=creator=cli
sleep 45
# Trigger the deployment
keptn trigger delivery --project=easytravel --service=easytravel-backend --image=dynatrace/easytravel-backend:2.0.0.3356 --labels=creator=cli
sleep 180
# Trigger the deployment
keptn trigger delivery --project=easytravel --service=easytravel-frontend --image=dynatrace/easytravel-frontend:2.0.0.3356 --labels=creator=cli
sleep 180
# Trigger the deployment
keptn trigger delivery --project=easytravel --service=easytravel-www --image=dynatrace/easytravel-nginx:2.0.0.3356 --labels=creator=cli
# Trigger the deployment
keptn trigger delivery --project=easytravel --service=easytravel-angular --image=dynatrace/easytravel-angular-frontend:2.0.0.3356 --labels=creator=cli

#sleep 180
#keptn trigger delivery --project=easytravel --service=loadgenerator --image=docker.io/dynatrace/easytravel-loadgen --sequence=delivery-direct --tag=latest --labels=creator=cli
