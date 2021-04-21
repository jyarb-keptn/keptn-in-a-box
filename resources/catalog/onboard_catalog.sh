#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then
    
    # The context for this script needs to be in examples/onboarding-carts
    echo "load shipyard.yaml"
    keptn create project keptnorders --shipyard=./shipyard.yaml
    keptn add-resource --project=keptnorders --resource=./shipyard.yaml --resourceUri=shipyard.yaml
    # Onboarding - prepare  Keptn
    echo "onboard services"
    keptn onboard service order-service --project=keptnorders --chart=./order-service
    keptn onboard service catalog-service --project=keptnorders --chart=./catalog-service
    keptn onboard service customer-service --project=keptnorders --chart=./customer-service
    keptn onboard service frontend-service --project=keptnorders --chart=./frontend-service
    
    # add jmeter resources for staging
    echo "load for project"
    #keptn add-resource --project=keptnorders --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    #keptn add-resource --project=keptnorders --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    echo "load service level jmeter scripts-staging"
    keptn add-resource --project=keptnorders --service=frontend-service --stage=staging --resource=jmeter/frontend-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=frontend-service --stage=staging --resource=jmeter/frontend-service/frontend-load.jmx --resourceUri=jmeter/frontend-load.jmx
    
    keptn add-resource --project=keptnorders --service=customer-service --stage=staging --resource=jmeter/customer-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=customer-service --stage=staging --resource=jmeter/customer-service/customer-load.jmx --resourceUri=jmeter/customer-load.jmx
    
    keptn add-resource --project=keptnorders --service=catalog-service --stage=staging --resource=jmeter/catalog-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=catalog-service --stage=staging --resource=jmeter/catalog-service/catalog-load.jmx --resourceUri=jmeter/catalog-load.jmx    
    
    keptn add-resource --project=keptnorders --service=order-service --stage=staging --resource=jmeter/order-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=order-service --stage=staging --resource=jmeter/order-service/order-load.jmx --resourceUri=jmeter/order-load.jmx    
    
    # add jmeter resources for production
    echo "load service level jmeter scripts-production"
    keptn add-resource --project=keptnorders --service=frontend-service --stage=production --resource=jmeter/frontend-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=frontend-service--stage=production --resource=jmeter/frontend-service/frontend-load.jmx --resourceUri=jmeter/frontend-load.jmx
    
    keptn add-resource --project=keptnorders --service=customer-service --stage=production --resource=jmeter/customer-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=customer-service --stage=production --resource=jmeter/customer-service/customer-load.jmx --resourceUri=jmeter/customer-load.jmx
    
    keptn add-resource --project=keptnorders --service=catalog-service --stage=production --resource=jmeter/catalog-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=catalog-service --stage=production --resource=jmeter/catalog-service/catalog-load.jmx --resourceUri=jmeter/catalog-load.jmx
    
    keptn add-resource --project=keptnorders --service=order-service --stage=production --resource=jmeter/order-service/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=order-service --stage=production --resource=jmeter/order-service/order-load.jmx --resourceUri=jmeter/order-load.jmx
    
    # add jmeter config for staging
    echo "load jmeter.conf.yaml"
    keptn add-resource --project=keptnorders --service=order-service --stage=staging --resource=jmeter/order-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=customer-service --stage=staging --resource=jmeter/customer-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=catalog-service --stage=staging --resource=jmeter/catalog-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=frontend-service --stage=staging --resource=jmeter/frontend-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    # add jmeter config for production
    keptn add-resource --project=keptnorders --service=order-service --stage=production --resource=jmeter/order-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=customer-service --stage=production --resource=jmeter/customer-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=catalog-service --stage=production --resource=jmeter/catalog-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=frontend-service --stage=production --resource=jmeter/frontend-service/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml    
else 
    echo "The helmcharts for catalog are not present"
fi 

