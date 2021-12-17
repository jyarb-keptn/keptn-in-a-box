#!/bin/bash
if [ $# -eq 2 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    TOKEN=$2
    echo "Domain has been passed: $DOMAIN"
    echo "token has been passed: $TOKEN"
else
    echo "No Domain has been passed, getting it from the Home-Ingress"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    echo "Domain: $DOMAIN"
fi

sed -e 's~domain.placeholder~'"$DOMAIN"'~' \
    -e 's~token.placeholder~'"$TOKEN"'~' \
    deployment.yaml > keptnwebservice/templates/deployment.yaml

#echo "install keptnwebservice via Helmchart"
#helm install --dry-run ./helm --namespace keptn --generate-name

keptn delete project keptnwebservice

sleep 5

#echo "install keptnwebservice via keptn"
keptn create project keptnwebservice --shipyard=./shipyard.yaml
keptn onboard service keptnwebservice --project=keptnwebservice --chart=./keptnwebservice
keptn trigger delivery --project=keptnwebservice --service=keptnwebservice --image=docker.io/grabnerandi/keptnwebservice --tag=2.0.0 --labels=creator=cli,build=01