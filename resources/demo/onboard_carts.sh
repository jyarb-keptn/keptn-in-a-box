#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "carts" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    #GIT_REPO=$GIT_SERVER/$GIT_USER/sockshop
    #keptn create project sockshop --shipyard=./shipyard.yaml --git-user=$GIT_USER --git-token=$GIT_TOKEN --git-remote-url=$GIT_REPO
    keptn add-resource --project=sockshop --resource=./shipyard.yaml --resourceUri=shipyard.yaml
    keptn add-resource --project=sockshop --stage=dev --resource=./shipyard.yaml --resourceUri=shipyard.yaml
    # Onboarding - prepare  Keptn
    keptn create service carts --project=sockshop
    #keptn onboard service carts --project=sockshop --chart=./carts
    keptn add-resource --project=sockshop --service=carts --all-stages --resource=./carts.tgz --resourceUri=helm/carts.tgz

    keptn add-resource --project=sockshop --stage=dev --service=carts --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=sockshop --stage=dev --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

    # Onboarding - prepare  Keptn
    keptn create service carts-db --project=sockshop
    #keptn onboard service carts-db --project=sockshop --chart=./carts-db
    keptn add-resource --project=sockshop --service=carts-db --all-stages --resource=./carts-db.tgz --resourceUri=helm/carts-db.tgz 
    #--deployment-strategy=direct


else 
    echo "The helmcharts for carts are not present"
fi 

