#!/bin/bash

# Usage:
# ./createApplication.sh APPLICATION

HOMEDIR="/home/dtu_training"

source ${HOMEDIR}/keptn-in-a-box/resources/dynatrace/utils.sh

cd ${HOMEDIR}/keptn-in-a-box/resources/dynatrace

readCredsFromFile
printVariables

echo $DT_TENANT
echo $DT_API_TOKEN

if [[ -z "$DT_TENANT" || -z "$DT_API_TOKEN" ]]; then
  echo "DT_TENANT & DT_API_TOKEN MUST BE SET!!"
  exit 1
fi

echo "============================================================="
echo "About to create Application Rule on Dynatrace Tenant: $DT_TENANT!"
echo "============================================================="
echo "Usage: ./createApplication.sh"
#read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key

####################################################################################################################
## createApplication(APPLICATIONURL)
####################################################################################################################

function createApplication() {
    APPLICATION=$1
    PAYLOAD='{
  "name": "'$APPLICATION'",
  "type": "AUTO_INJECTED",
  "realUserMonitoringEnabled": true,
  "costControlUserSessionPercentage": 100,
  "loadActionKeyPerformanceMetric": "VISUALLY_COMPLETE",
  "sessionReplayConfig": {
    "enabled": true,
    "costControlPercentage": 100,
    "enableCssResourceCapturing": true,
    "cssResourceCapturingExclusionRules": []
  },
  "xhrActionKeyPerformanceMetric": "ACTION_DURATION",
  "loadActionApdexSettings": {
    "toleratedThreshold": 3000,
    "frustratingThreshold": 12000,
    "toleratedFallbackThreshold": 3000,
    "frustratingFallbackThreshold": 12000
  },
  "xhrActionApdexSettings": {
    "toleratedThreshold": 3000,
    "frustratingThreshold": 12000,
    "toleratedFallbackThreshold": 3000,
    "frustratingFallbackThreshold": 12000
  },
  "customActionApdexSettings": {
    "toleratedThreshold": 3000,
    "frustratingThreshold": 12000,
    "toleratedFallbackThreshold": 3000,
    "frustratingFallbackThreshold": 12000
  },
  "waterfallSettings": {
    "uncompressedResourcesThreshold": 860,
    "resourcesThreshold": 100000,
    "resourceBrowserCachingThreshold": 50,
    "slowFirstPartyResourcesThreshold": 200000,
    "slowThirdPartyResourcesThreshold": 200000,
    "slowCdnResourcesThreshold": 200000,
    "speedIndexVisuallyCompleteRatioThreshold": 50
  },
  "monitoringSettings": {
    "fetchRequests": false,
    "xmlHttpRequest": true,
    "javaScriptFrameworkSupport": {
      "angular": true,
      "dojo": false,
      "extJS": false,
      "icefaces": false,
      "jQuery": false,
      "mooTools": false,
      "prototype": false,
      "activeXObject": false
    },
    "contentCapture": {
      "resourceTimingSettings": {
        "w3cResourceTimings": true,
        "nonW3cResourceTimings": false,
        "nonW3cResourceTimingsInstrumentationDelay": 50,
        "resourceTimingCaptureType": "CAPTURE_FULL_DETAILS",
        "resourceTimingsDomainLimit": 10
      },
      "javaScriptErrors": true,
      "timeoutSettings": {
        "timedActionSupport": false,
        "temporaryActionLimit": 0,
        "temporaryActionTotalTimeout": 100
      },
      "visuallyCompleteAndSpeedIndex": true,
      "visuallyComplete2Settings": {
        "excludeUrlRegex": "",
        "ignoredMutationsList": "",
        "mutationTimeout": 50,
        "inactivityTimeout": 1000,
        "threshold": 50
      }
    },
    "excludeXhrRegex": "",
    "correlationHeaderInclusionRegex": "",
    "injectionMode": "JAVASCRIPT_TAG",
    "addCrossOriginAnonymousAttribute": true,
    "scriptTagCacheDurationInHours": 1,
    "libraryFileLocation": "",
    "monitoringDataPath": "",
    "customConfigurationProperties": "",
    "serverRequestPathId": "",
    "secureCookieAttribute": false,
    "cookiePlacementDomain": "",
    "cacheControlHeaderOptimizations": true,
    "advancedJavaScriptTagSettings": {
      "syncBeaconFirefox": false,
      "syncBeaconInternetExplorer": false,
      "instrumentUnsupportedAjaxFrameworks": false,
      "specialCharactersToEscape": "",
      "maxActionNameLength": 100,
      "maxErrorsToCapture": 10,
      "additionalEventHandlers": {
        "userMouseupEventForClicks": false,
        "clickEventHandler": false,
        "mouseupEventHandler": false,
        "blurEventHandler": false,
        "changeEventHandler": false,
        "toStringMethod": false,
        "maxDomNodesToInstrument": 5000
      },
      "eventWrapperSettings": {
        "click": false,
        "mouseUp": false,
        "change": false,
        "blur": false,
        "touchStart": false,
        "touchEnd": false
      },
      "globalEventCaptureSettings": {
        "mouseUp": true,
        "mouseDown": true,
        "click": true,
        "doubleClick": true,
        "keyUp": true,
        "keyDown": true,
        "scroll": true,
        "additionalEventCapturedAsUserInput": ""
      }
    }
  },
  "userTags": [
    {
      "uniqueId": 1,
      "metadataId": 1,
      "cleanupRule": "Hi,.(.*+)",
      "ignoreCase": false
    }
  ],
  "userActionAndSessionProperties": [],
  "userActionNamingSettings": {
    "placeholders": [],
    "loadActionNamingRules": [
      {
        "template": "{userInteraction (default)} on ''{elementIdentifier (default)}'' - {pageUrlPath (default)}",
        "conditions": [],
        "useOrConditions": false
      }
    ],
    "xhrActionNamingRules": [
      {
        "template": "{userInteraction (default)} on ''{elementIdentifier (default)}'' - {pageUrlPath (default)}",
        "conditions": [],
        "useOrConditions": false
      }
    ],
    "customActionNamingRules": [],
    "ignoreCase": true,
    "useFirstDetectedLoadAction": false,
    "splitUserActionsByDomain": true,
    "queryParameterCleanups": [
      "cfid",
      "phpsessid",
      "__sid",
      "cftoken",
      "sid"
    ]
  },
  "metaDataCaptureSettings": [
    {
      "type": "CSS_SELECTOR",
      "capturingName": "a.greeting",
      "name": "VisitTag0",
      "uniqueId": 1,
      "publicMetadata": false,
      "useLastValue": false
    }
  ],
  "conversionGoals": []
}'

  echo ""
  echo "Creating Application $APPLICATION($APPLICATION)"
  echo "POST https://$DT_TENANT/api/config/v1/applications/web"
  echo "$PAYLOAD"
  curl -X POST \
          "https://$DT_TENANT/api/config/v1/applications/web" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d "$PAYLOAD" \
          -o $APPLICATION.json
  
  jq -r . ./$APPLICATION.json
  echo ""

}

function createDetectionRule() {
    APPLICATION=$1
    TOKEN_FILE="$APPLICATION.json"

    if [ -f "$TOKEN_FILE" ]; then
        echo "Reading token from file $TOKEN_FILE"
        TOKENJSON=$(cat $TOKEN_FILE)
        APPLICATION_ID=$(echo $TOKENJSON | jq -r '.id')
    fi

    PAYLOAD='{
  "applicationIdentifier": "'$APPLICATION_ID'",
  "filterConfig": {
    "pattern": "'$APPLICATION'",
    "applicationMatchType": "CONTAINS",
    "applicationMatchTarget": "DOMAIN"
   }
  }'

  echo ""
  echo "Creating ApplicationDetectionRule $APPLICATION($APPLICATION)"
  echo "POST https://$DT_TENANT/api/config/v1/applicationDetectionRules"
  echo "$PAYLOAD"
  curl -X POST \
          "https://$DT_TENANT/api/config/v1/applicationDetectionRules" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d "$PAYLOAD" \
          -o $APPLICATIONRULE.json

  jq -r . ./$APPLICATIONRULE.json
  echo ""

}

###########################################################################
# Setup easytravel staging Application
###########################################################################
createApplication "easytravel-angular.easytravel-staging"
createDetectionRule "easytravel-angular.easytravel-staging"
###########################################################################
# Setup easytravel production Application
###########################################################################
createApplication "easytravel-angular.easytravel-production"
createDetectionRule "easytravel-angular.easytravel-production"
###########################################################################
# Setup keptnorders staging Application
###########################################################################
createApplication "frontend.keptnorders-staging"
createDetectionRule "frontend.keptnorders-staging"
###########################################################################
# Setup keptnorders production Application
###########################################################################
createApplication "frontend.keptnorders-production"
createDetectionRule "frontend.keptnorders-production"
###########################################################################
# Setup sockshop Application
###########################################################################
createApplication "SockShop"
createDetectionRule "SockShop"