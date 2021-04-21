#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog-service" ]]; then

    # The context for this script needs to be in examples/onboarding-carts
    echo "Adding the SLI for the Project to all Stages"
    keptn add-resource --project=keptnorders --resource=dynatrace-sli-config-keptnorders.yaml --resourceUri=dynatrace/sli.yaml
      
    kubectl apply -f dynatrace-sli-config-keptnorders.yaml
    
    keptn configure monitoring dynatrace --project=keptnorders

    echo "Setting up QualityGate to Staging"
    keptn add-resource --project=keptnorders --stage=staging --service=order-service --resource=quality-gates/order-service/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=staging --service=catalog-service --resource=quality-gates/catalog-service/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=staging --service=customer-service --resource=quality-gates/customer-service/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=staging --service=frontend-service --resource=quality-gates/frontend-service/simple_slo.yaml --resourceUri=slo.yaml
    echo "Setting up QualityGate to Production"
    keptn add-resource --project=keptnorders --stage=production --service=frontend-service --resource=quality-gates/frontend-service/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=order-service --resource=quality-gates/order-service/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=customer-service  --resource=quality-gates/customer-service/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=catalog-service  --resource=quality-gates/catalog-service/simple_slo.yaml --resourceUri=slo.yaml

else 
    echo "The helmcharts for catalog are not present"
fi 

