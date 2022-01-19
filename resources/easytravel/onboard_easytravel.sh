#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "easytravel-frontend" ]]; then
    
    # The context for this script needs to be in examples/onboarding-carts
    echo "load shipyard.yaml"
    keptn create project easytravel --shipyard=./shipyard-direct.yaml
    keptn add-resource --project=easytravel --resource=./shipyard-direct.yaml --resourceUri=shipyard.yaml
    # Onboarding - prepare  Keptn
    echo "onboard services"
    #keptn onboard service easytravel-mongodb --project=easytravel --chart=./easytravel-mongodb
    keptn create service easytravel-mongodb --project=easytravel
    keptn add-resource --project=easytravel --service=easytravel-mongodb --all-stages --resource=./easytravel-mongodb.tgz --resourceUri=helm/easytravel-mongodb.tgz
    #keptn onboard service easytravel-backend --project=easytravel --chart=./easytravel-backend
    keptn create service easytravel-backend --project=easytravel
    keptn add-resource --project=easytravel --service=easytravel-backend --all-stages --resource=./easytravel-backend.tgz --resourceUri=helm/easytravel-backend.tgz
    #keptn onboard service easytravel-frontend --project=easytravel --chart=./easytravel-frontend
    keptn create service easytravel-frontend --project=easytravel
    keptn add-resource --project=easytravel --service=easytravel-frontend --all-stages --resource=./easytravel-frontend.tgz --resourceUri=helm/easytravel-frontend.tgz
    #keptn onboard service easytravel-www --project=easytravel --chart=./easytravel-www
    keptn create service easytravel-www --project=easytravel
    keptn add-resource --project=easytravel --service=easytravel-www --all-stages --resource=./easytravel-www.tgz --resourceUri=helm/easytravel-www.tgz
    #keptn onboard service easytravel-angular --project=easytravel --chart=./easytravel-angular
    keptn create service easytravel-angular --project=easytravel
    keptn add-resource --project=easytravel --service=easytravel-angular --all-stages --resource=./easytravel-angular.tgz --resourceUri=helm/easytravel-angular.tgz
    #keptn onboard service loadgenerator --project=easytravel --chart=./loadgen
    
    # add jmeter resources for staging
    echo "load for project"
    keptn add-resource --project=keptnorders --resource=jmeter/frontend/et-basiccheck.jmx --resourceUri=jmeter/et-basiccheck.jmx
    #keptn add-resource --project=keptnorders --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    echo "load service level jmeter scripts-staging"
    keptn add-resource --project=easytravel --service=easytravel-frontend --stage=staging --resource=jmeter/frontend/et-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-frontend --stage=staging --resource=jmeter/frontend/et-load.jmx --resourceUri=jmeter/et-load.jmx
    
    keptn add-resource --project=easytravel --service=easytravel-backend --stage=staging --resource=jmeter/backend/be-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-backend --stage=staging --resource=jmeter/backend/be-load.jmx --resourceUri=jmeter/be-load.jmx
    
    keptn add-resource --project=easytravel --service=easytravel-www --stage=staging --resource=jmeter/www/www-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-www --stage=staging --resource=jmeter/www/www-load.jmx --resourceUri=jmeter/www-load.jmx
    
    keptn add-resource --project=easytravel --service=easytravel-angular --stage=staging --resource=jmeter/angular/angular-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-angular --stage=staging --resource=jmeter/angular/angular-load.jmx --resourceUri=jmeter/angular-load.jmx
     
    # add jmeter resources for production
    echo "load service level jmeter scripts-production"
    keptn add-resource --project=easytravel --service=easytravel-frontend --stage=production --resource=jmeter/frontend/et-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-frontend --stage=production --resource=jmeter/frontend/et-load.jmx --resourceUri=jmeter/et-load.jmx
    
    keptn add-resource --project=easytravel --service=easytravel-backend --stage=production --resource=jmeter/backend/be-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-backend --stage=production --resource=jmeter/backend/be-load.jmx --resourceUri=jmeter/be-load.jmx
    
    keptn add-resource --project=easytravel --service=easytravel-www --stage=production --resource=jmeter/www/www-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-www --stage=production --resource=jmeter/www/www-load.jmx --resourceUri=jmeter/www-load.jmx
    
    keptn add-resource --project=easytravel --service=easytravel-angular --stage=production --resource=jmeter/angular/angular-basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=easytravel --service=easytravel-angular --stage=production --resource=jmeter/angular/angular-load.jmx --resourceUri=jmeter/angular-load.jmx
    
    
    # add jmeter config for staging
    echo "load jmeter.conf.yaml"
    keptn add-resource --project=easytravel --service=easytravel-frontend --stage=staging --resource=jmeter/frontend/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=easytravel --service=easytravel-backend --stage=staging --resource=jmeter/backend/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=easytravel --service=easytravel-www --stage=staging --resource=jmeter/www/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=easytravel --service=easytravel-angular --stage=staging --resource=jmeter/angular/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml

    # add jmeter config for production
    keptn add-resource --project=easytravel --service=easytravel-frontend --stage=production --resource=jmeter/frontend/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=easytravel --service=easytravel-backend --stage=production --resource=jmeter/backend/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=easytravel --service=easytravel-www --stage=production --resource=jmeter/www/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=easytravel --service=easytravel-angular --stage=production --resource=jmeter/angular/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    
else 
    echo "The helmcharts for easytravel are not present"
fi 

