#!/bin/bash -x
    
    echo "Create Services...."

keptn create service easytravel-angular --project=dynatrace
keptn create service easytravel-frontend --project=dynatrace
keptn create service easytravel-backend --project=dynatrace
keptn create service easytravel-www --project=dynatrace