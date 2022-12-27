#!/bin/bash -x

evaldate=`date +%s%3N`
buildid=`date +%m%d%H%M`
# Trigger the deployment
keptn trigger delivery --project=sockshop --service=carts-db --image=mongo:4.2.2 --sequence=delivery-direct --labels=buildId=${buildid},version=4.2.2,evaltime=${evaldate},executedBy=cli
sleep 30
# Trigger the deployment
keptn trigger delivery --project=sockshop --service=carts --image=keptnexamples/carts:0.12.1 --labels=buildId=${buildid},version=0.12.1,evaltime=${evaldate},executedBy=cli
sleep 30

