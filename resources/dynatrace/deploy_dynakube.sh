#!/bin/bash
source ./utils.sh

OPERATOR_VERSION=$1

deploy_operator () {
export DT_API_TOKEN=$DT_API_TOKEN
export DT_PAAS_TOKEN=$DT_PAAS_TOKEN
export DT_API_URL=https://$DT_TENANT/api

# Install the operator
echo "Creating dynatrace K8s namespace"
kubectl create namespace dynatrace
echo "Downloading the ${OPERATOR_VERSION} dynatrace operator release (definition) (-L for follow redirect"
#curl -L -o kubernetes.yaml https://github.com/Dynatrace/dynatrace-operator/releases/latest/download/kubernetes.yaml
#curl -L -o kubernetes.yaml https://github.com/Dynatrace/dynatrace-operator/releases/download/${OPERATOR_VERSION}/kubernetes.yaml
kubectl apply -f https://github.com/Dynatrace/dynatrace-operator/releases/download/${OPERATOR_VERSION}/kubernetes.yaml
#echo "Create operator/webhook via kubctl"
#kubectl create -f kubernetes.yaml
#kubectl -n dynatrace create secret generic dynakube --from-literal="apiToken=$DT_API_TOKEN" --from-literal="paasToken=$DT_PAAS_TOKEN" --from-literal="dataIngestToken=$DT_API_TOKEN"
echo "Wait for pods to start"
sleep 30
#kubectl -n dynatrace wait pod --for=condition=ready -l internal.dynatrace.com/app=webhook --timeout=
kubectl -n dynatrace wait pod --for=condition=ready --selector=app.kubernetes.io/name=dynatrace-operator,app.kubernetes.io/component=webhook --timeout=300s

##former method to pull file
#echo "Download and apply the cr.yaml"
##curl -Lo dynaKubeCr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-operator/v0.4.2/config/samples/classicFullStack.yaml
#curl -Lo dynaKubeCr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-operator/${OPERATOR_VERSION}/config/samples/classicFullStack.yaml

## 
#echo "install CSI driver...."
#kubectl apply -f https://github.com/Dynatrace/dynatrace-operator/releases/latest/download/kubernetes-csi.yaml

echo "copy file..."
#cp dynakube.yaml dynaKubeCr.yaml
## use for file based
cp ~/dtkube/dynakube.yaml dynaKubeCr.yaml

echo "transform file..."
#sed -i "s+apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api+apiUrl: $DT_API_URL+g" dynaKubeCr.yaml
#sed -i "s+apiToken: api.token.placeholder+apiToken: $DT_API_TOKEN+g" dynaKubeCr.yaml
#sed -i "s+dataIngestToken: paas.token.placeholder+dataIngestToken: $DT_PAAS_TOKEN+g" dynaKubeCr.yaml
## not needed
#sed -i "s/# enableIstio: false/enableIstio: true/g" dynaKubeCr.yaml
#sed -i "s/#      - metrics-ingest/      - metrics-ingest/g" dynaKubeCr.yaml

echo "kubctl apply..."
kubectl apply -f dynaKubeCr.yaml
}

echo "Deploying the dynakube operator..."
readCredsFromFile
printVariables
echo "Are the values correct? Continue? [y/n]"
read REPLY
case "$REPLY" in
    [yY])
        deploy_operator
        ;;
    *)
        echo "Ok then run ./save-credentials.sh to set the new credentials"
        exit
        ;;
esac
exit
