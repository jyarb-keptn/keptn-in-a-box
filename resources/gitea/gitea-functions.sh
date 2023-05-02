#!/bin/bash
# Gitea Documentation
# https://gitea.com/gitea/helm-chart/#configuration

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from the Home-Ingress"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    echo "Domain: $DOMAIN"
fi

# Load git vars
source ~/keptn-in-a-box/resources/gitea/gitea-vars.sh $DOMAIN

# Create Token
createApiToken(){
    echo "Creating token for $GIT_USER from $GIT_SERVER"
    curl -v --user $GIT_USER:$GIT_PASSWORD \
    -X POST "$GIT_SERVER/api/v1/users/$GIT_USER/tokens" \
    -H "accept: application/json" -H "Content-Type: application/json; charset=utf-8" \
    -d "{ \"name\": \"$GIT_TOKEN\", \"scopes\": [\"all\"] }" -o $GIT_TOKEN.json
}

getApiTokens(){
    echo "Get tokens for $GIT_USER from $GIT_SERVER"
    curl -v --user $GIT_USER:$GIT_PASSWORD \
    -X GET "$GIT_SERVER/api/v1/users/$GIT_USER/tokens" \
    -H "accept: application/json" -H "Content-Type: application/json; charset=utf-8"
}

deleteApiToken(){
    echo "Deleting token for $GIT_USER from $GIT_SERVER"
    curl -v --user $GIT_USER:$GIT_PASSWORD \
    -X DELETE "$GIT_SERVER/api/v1/users/$GIT_USER/tokens/$TOKEN_ID" \
    -H "accept: application/json" -H "Content-Type: application/json; charset=utf-8" 
}

readApiTokenFromFile() {
    TOKEN_FILE=~/keptn-in-a-box/resources/gitea/$TOKEN_FILE
    echo "TOKEN_FILE: $TOKEN_FILE"
    if [ -f "$TOKEN_FILE" ]; then
        echo "Reading token from file $TOKEN_FILE"
        TOKENJSON=$(cat $TOKEN_FILE)
        API_TOKEN=$(echo $TOKENJSON | jq -r '.sha1')
        TOKEN_ID=$(echo $TOKENJSON | jq -r '.id')
        echo "tokenId: $TOKEN_ID hash: $API_TOKEN"
        export GIT_TOKEN=$API_TOKEN
    fi
}

createKeptnRepos() {
    echo "Creating repositories for Keptn projects "
    for project in `keptn get projects | awk '{ if (NR!=1) print $1}'`;
    do 
        if [ "${project}" != "NAME" ]; then
            createKeptnRepo $project
        fi
    done
}

updateKeptnRepos(){
    echo "updating repositories for Keptn projects "
    for project in `keptn get projects | awk '{ if (NR!=1) print $1}'`;
    do 
    KEPTN_PROJECT=$project
    echo "$GIT_SERVER/$GIT_USER/$KEPTN_PROJECT.git"
    if [ "${project}" != "NAME" ]; then
        keptn update project $KEPTN_PROJECT --git-user=$GIT_USER --git-token=$API_TOKEN --git-remote-url=$GIT_SERVER/$GIT_USER/$KEPTN_PROJECT.git
    fi
    done
}

updateKeptnRepo(){
    if [ "$1" != "NAME" ]; then
      KEPTN_PROJECT=$1
      keptn update project $KEPTN_PROJECT --git-user=$GIT_USER --git-token=$API_TOKEN --git-remote-url=$GIT_SERVER/$GIT_USER/$KEPTN_PROJECT.git
    fi
}

createKeptnProject(){
    if [ "$1" != "NAME" ]; then
      KEPTN_PROJECT=$1
      keptn create project $KEPTN_PROJECT --shipyard=./shipyard.yaml --git-user=$GIT_USER --git-token=$GIT_TOKEN --git-remote-url=$GIT_REPO
    fi
}

createKeptnRepoManually(){
    readApiTokenFromFile
    createKeptnRepo $1
}

createKeptnRepo(){
    echo "Creating and migrating Keptn project to self-hosted git for $1"
    if [ "$1" != "NAME" ]; then
      createGitRepo $1
      updateKeptnRepo $1
    fi
}

createGitRepo(){
    echo "Create repo for project $1"
    # Create Repo with Token
    curl -X POST "$GIT_SERVER/api/v1/user/repos?access_token=$API_TOKEN" \
    -H "accept: application/json" -H "Content-Type: application/json" \
    -d "{ \"auto_init\": false, \"default_branch\": \"master\", \"name\": \"$1\", \"private\": false}"
}

echo "gitea functions have been loaded"

return
