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
    templates/deployment.yaml > templates/gen/deployment.yaml

echo "install gitea via Helmchart"
helm install -f templates/gen/deployment.yaml --namespace keptn --generate-name