#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "unleash" ]]; then

    UNLEASH_TOKEN=$(echo -n keptn:keptn | base64)
    UNLEASH_BASE_URL=$(echo http://unleash.unleash-dev.$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}'))
    #UNLEASH_BASE_URL=$(echo http://unleash.unleash-dev.kiab.pcjeffint.com)
    
    # The context for this script needs to be in examples/unleash-server
    keptn create project unleash --shipyard=./shipyard.yaml
    #keptn onboard service unleash-db --project=unleash --chart=./unleash-db
    keptn add-resource --project=unleash --service=unleash-db --all-stages --resource=./unleash-db --resourceUri=helm/unleash-db
    #keptn onboard service unleash --project=unleash --chart=./unleash
    keptn add-resource --project=unleash --service=unleash --all-stages --resource=./unleash --resourceUri=helm/unleash
    keptn trigger delivery --project=unleash --service=unleash-db --image=postgres:10.4
    keptn trigger delivery --project=unleash --service=unleash --image=docker.io/keptnexamples/unleash:1.0.1

    # Configure Keptn
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/release-0.3.2/deploy/service.yaml -n keptn

else 
    echo "The helmcharts for unleash are not present"
fi 

