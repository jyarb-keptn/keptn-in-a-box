#!/bin/bash
# Function file for adding created keptn repos to a self-hosted git repository

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    PROJECT=$2
    echo "Domain has been passed: $DOMAIN for project: $PROJECT"
else
    echo "No Domain has been passed, getting it from the Home-Ingress"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    PROJECT=$2
    echo "Domain: $DOMAIN"
fi

source ~/keptn-in-a-box/resources/gitea/gitea-functions.sh ${DOMAIN}

# get Tokens for the User
#getApiTokens

# create an Api Token
#createApiToken

# read the Token and keep the hash in memory
readApiTokenFromFile

echo "GIT_USER: ${GIT_USER}"
echo "GIT_PW: ${GIT_PASSWORD}"
echo "GIT_TOKEN: ${GIT_TOKEN}"
echo "GIT_SERVER: ${GIT_SERVER}"

GIT_REPO=$GIT_SERVER/$GIT_USER/$PROJECT

echo "GIT_REPO: ${GIT_REPO}"

createGitRepo $PROJECT

createKeptnProject $PROJECT
