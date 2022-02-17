#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "unleash" ]]; then

    UNLEASH_TOKEN=$(echo -n keptn:keptn | base64)
    UNLEASH_BASE_URL=$(echo http://unleash.unleash-dev.$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}'))
    #UNLEASH_BASE_URL=$(echo http://unleash.unleash-dev.kiab.pcjeffint.com)
    
    # The context for this script needs to be in examples/unleash-server
    # Creating the project has been moved.
    #keptn create project unleash --shipyard=./shipyard.yaml
    #keptn onboard service unleash-db --project=unleash --chart=./unleash-db
    keptn create service unleash-db --project=unleash
    keptn add-resource --project=unleash --service=unleash-db --all-stages --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
    keptn add-resource --project=unleash --service=unleash-db --all-stages --resource=./unleash-db.tgz --resourceUri=helm/unleash-db.tgz
    #keptn onboard service unleash --project=unleash --chart=./unleash
    keptn create service unleash --project=unleash
    keptn add-resource --project=unleash --service=unleash --all-stages --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
    keptn add-resource --project=unleash --service=unleash --all-stages --resource=./unleash.tgz --resourceUri=helm/unleash.tgz
    # trigger the delivery
    keptn trigger delivery --project=unleash --service=unleash-db --image=postgres:10.4
    keptn trigger delivery --project=unleash --service=unleash --image=docker.io/keptnexamples/unleash:1.0.1

    # Configure Keptn
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/release-0.3.2/deploy/service.yaml -n keptn

else 
    echo "The helmcharts for unleash are not present"
fi 

