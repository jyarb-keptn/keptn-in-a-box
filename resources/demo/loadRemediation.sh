#!/bin/bash -x

keptn add-resource --project=sockshop --resource=./shipyard-remediation.yaml --resourceUri=shipyard.yaml

keptn add-resource --project=sockshop --stage=production --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml

keptn add-resource --project=sockshop --stage=staging --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml
