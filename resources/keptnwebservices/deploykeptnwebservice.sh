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

echo "creating tarball...."
tar -cvzf keptnwebservice.tgz keptnwebservice
echo "install keptnwebservice via keptn CLI..."
#keptn create project webservices --shipyard=./shipyard.yaml
#keptn onboard service keptnwebservice --project=webservices --chart=./keptnwebservice
keptn create service keptnwebservice --project=webservices
keptn add-resource --project=webservices --service=keptnwebservice --all-stages --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
keptn add-resource --project=webservices --service=keptnwebservice --all-stages --resource=./keptnwebservice.tgz --resourceUri=helm/keptnwebservice.tgz
echo "trigger delivery..."
keptn trigger delivery --project=webservices --service=keptnwebservice --image=docker.io/grabnerandi/keptnwebservice:2.0.0 --labels=creator=cli,build=01