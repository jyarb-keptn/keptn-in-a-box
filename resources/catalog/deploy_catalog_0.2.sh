#!/bin/bash -x

evaldate=`date +%s%3N`
buildid=`date +%m%d%H%M`
# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=order --image=dtdemos/dt-orders-order-service:1.0.0 --labels=buildId=${buildid},version=1.0.0,evaltime=${evaldate},executedBy=cli
sleep 30
# Trigger the deployment
keptn trigger delivery --project=keptnorders --service=frontend --image=dtdemos/dt-orders-frontend:1.0.0 --labels=buildId=${buildid},version=1.0.0,evaltime=${evaldate},executedBy=cli
sleep 60