#!/bin/bash
# Function file for deleteing a keptn repos to a self-hosted git repository

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from the Home-Ingress"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    echo "Domain: $DOMAIN"
fi

source ./gitea-functions.sh $DOMAIN

# get Tokens for the User
#getApiTokens

# create an Api Token
#createApiToken

# read the Token and keep the hash in memory
readApiTokenFromFile

GIT_REPO="keptnorders"

curl -X DELETE "$GIT_SERVER/api/v1/repos/$GIT_USER/$GIT_REPO?token=$API_TOKEN" -H  "accept: application/json"
