#!/bin/bash -x

evaldate=`date +%s%3N`

keptn trigger delivery --project=keptnorders --stage=prod-p --service=order --image=dtdemos/dt-orders-order-service:1.0.0 --labels=buildId=1.0.0,version=1.0.0,evaltime=${evaldate},executedBy=manual
rder
keptn trigger delivery --project=keptnorders --stage=prod-p --service=customer --image=dtdemos/dt-orders-customer-service:1.0.0 --labels=buildId=1.0.0,version=1.0.0,evaltime=${evaldate},executedBy=manual
keptn trigger delivery --project=keptnorders --stage=prod-p --service=catalog --image=dtdemos/dt-orders-catalog-service:1.0.0 --labels=buildId=1.0.0,version=1.0.0,evaltime=${evaldate},executedBy=manual
keptn trigger delivery --project=keptnorders --stage=prod-p --service=frontend --image=dtdemos/dt-orders-frontend:1.0.0 --labels=buildId=1.0.0,version=1.0.0,evaltime=${evaldate},executedBy=manual