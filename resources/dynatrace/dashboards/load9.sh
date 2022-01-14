#!/bin/bash
HOMEDIR=$1

source ${HOMEDIR}/resources/dynatrace/utils.sh

cp ${HOMEDIR}/resources/dynatrace/creds_dt.json .

readCredsFromFile
printVariables

echo $DT_TENANT
echo $DT_API_TOKEN

DT_TENANT=$DT_TENANT
DT_API_TOKEN=$DT_API_TOKEN

DOMAIN=$2
OWNER=$3

curl --location --request POST 'https://'${DT_TENANT}'/api/config/v1/dashboards?Api-Token='${DT_API_TOKEN}'' \
--header 'Content-Type: application/json; charset=utf-8' \
--data-raw '{
 "dashboardMetadata": {
    "name": "KQG;project=dynatrace;stage=quality-gate;service=www",
    "shared": false,
    "owner": "'${OWNER}'",
    "dashboardFilter": {
      "timeframe": "-30m",
      "managementZone": {
        "id": "-5502479898842519396",
        "name": "ez-travel"
      }
    },
    "tags": [
      "comp",
      "delivery-demo",
      "staging"
    ]
  },
  "tiles": [
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 798,
        "left": 836,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Worker Process Count (Avg);sli=proc_count;",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:tech.generic.processCount",
              "aggregation": "AVG",
              "type": "LINE",
              "entityType": "PROCESS_GROUP_INSTANCE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "PROCESS_GROUP_INSTANCE": {
            "AUTO_TAGS": [
              "managed:www"
            ]
          }
        }
      }
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 266,
        "left": 418,
        "width": 912,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "KQG.Total.Pass=90%;KQG.Total.Warning=70%;KQG.Compare.WithScore=pass;KQG.Compare.Results=1;KQG.Compare.Function=avg"
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 0,
        "width": 418,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response time (P95);sli=response_time_p95;pass=<+50%,<1000",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:service.response.time",
              "aggregation": "PERCENTILE",
              "percentile": 95,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_service:www",
              "keptn_managed"
            ]
          }
        }
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 570,
        "left": 0,
        "width": 418,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response time (P90);sli=response_time_p90;pass=<+50%,<550",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:service.response.time",
              "aggregation": "PERCENTILE",
              "percentile": 90,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_service:www",
              "keptn_managed"
            ]
          }
        }
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 798,
        "left": 0,
        "width": 418,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response time (P50);sli=response_time_p50;pass=<+50%,<500",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:service.response.time",
              "aggregation": "PERCENTILE",
              "percentile": 50,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_service:www",
              "keptn_managed"
            ]
          }
        }
      }
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 304,
        "left": 0,
        "width": 418,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Service Performance (SLI/SLO)"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 304,
        "left": 836,
        "width": 380,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Process Metrics (SLI/SLO)"
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 570,
        "left": 836,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Process Memory;sli=process_memory",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:tech.generic.mem.workingSetSize",
              "aggregation": "AVG",
              "type": "LINE",
              "entityType": "PROCESS_GROUP_INSTANCE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "PROCESS_GROUP_INSTANCE": {
            "AUTO_TAGS": [
              "managed:www"
            ]
          }
        }
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 836,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Process CPU;sli=process_cpu;pass=<20;warning=<50;key=false",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:tech.generic.cpu.usage",
              "aggregation": "AVG",
              "type": "LINE",
              "entityType": "PROCESS_GROUP_INSTANCE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "PROCESS_GROUP_INSTANCE": {
            "AUTO_TAGS": [
              "managed:www"
            ]
          }
        }
      }
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 304,
        "left": 418,
        "width": 418,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Service Errors & Throughput (SLI/SLO)"
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 418,
        "width": 418,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Failure Rate (Avg);sli=error_rate;pass=<=1;warning=<=2;weight=2",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:service.errors.server.rate",
              "aggregation": "AVG",
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_service:www",
              "keptn_managed"
            ]
          }
        }
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 570,
        "left": 418,
        "width": 418,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Throughput (per min);sli=svc_tp_min;pass=>200",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:service.requestCount.total",
              "aggregation": "NONE",
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "MINUTE"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_service:www",
              "keptn_managed"
            ]
          }
        }
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 798,
        "left": 418,
        "width": 418,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Calls to backend services (per min);sli=svc2svc_calls;",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:service.nonDbChildCallCount",
              "aggregation": "NONE",
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "MINUTE"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_service:www",
              "keptn_managed"
            ]
          }
        }
      }
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 0,
        "width": 1216,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "## SLO-based Quality Gate Dashboard based on important quality metrics"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 266,
        "left": 0,
        "width": 418,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "**Release Validation Criteria:**"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 38,
        "left": 0,
        "width": 1216,
        "height": 76
      },
      "tileFilter": {},
      "markdown": "This dashboard will be analyzed as part of your DevOps pipelines when your service gets quality analyzed in staging\n\nTODO: Select your Management Zone, Add your relevant metrics (SLIs/SLOs)"
    },
    {
      "name": "Problems",
      "tileType": "OPEN_PROBLEMS",
      "configured": true,
      "bounds": {
        "top": 114,
        "left": 0,
        "width": 152,
        "height": 152
      },
      "tileFilter": {}
    }
  ]
}'