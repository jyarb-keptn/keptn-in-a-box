#!/bin/bash

# =======
# clean up script for stale replica sets
#

rm rscleanup.sh

kubectl get --all-namespaces rs -o json|jq -r '.items[] | select(.spec.replicas | contains(0)) | "kubectl delete rs --namespace=\(.metadata.namespace) \(.metadata.name)"' >> rscleanup.sh

chmod +x rscleanup.sh

./rscleanup.sh
