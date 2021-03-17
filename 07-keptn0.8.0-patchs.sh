#!/bin/bash
# perform steps for keptn 0.8.0
KEPTN_IN_A_BOX_DIR="~/keptn-in-a-box"

cd ~/examples/onboarding-carts
keptn add-resource --project=sockshop --resource=shipyard.yaml --resourceUri=shipyard.yaml
#cd ~/keptn-in-a-box/resources/demo
#keptn add-resource --project=sockshop --stage=dev --service=carts-db --resource=slo-carts-db.yaml --resourceUri=slo.yaml

cd ~/keptn-in-a-box/resources/gitea
./update-git-keptn-post-flight.sh

#cd ~/examples/onboarding-carts
#keptn add-resource --project=sockshop --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml

cd ~/keptn-in-a-box/resources/demo
./deploy_carts_0.sh

#keptn configure monitoring dynatrace --project=performance
