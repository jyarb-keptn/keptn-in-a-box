#!/bin/bash
HOMEDIR="/home/dtu_training"

source ${HOMEDIR}/keptn-in-a-box/resources/dynatrace/utils.sh

cp ${HOMEDIR}keptn-in-a-box/resources/dynatrace/creds_dt.json .

readCredsFromFile
printVariables

echo $DT_TENANT
echo $DT_API_TOKEN

DT_TENANT=$DT_TENANT
DT_API_TOKEN=$DT_API_TOKEN

DOMAIN=$1
OWNER=$2

curl --location --request POST 'https://'${DT_TENANT}'/api/config/v1/dashboards?Api-Token='${DT_API_TOKEN}'' \
--header 'Content-Type: application/json; charset=utf-8' \
--data-raw '{
    "dashboardMetadata": {
    "name": "SLO Dashboard for Tenant comp",
    "shared": false,
    "owner": "'${OWNER}'",
    "tags": [
      "slo",
      "tnt-comp-svc"
    ]
  },
  "tiles": [
    {
      "name": "Availability",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 152,
        "left": 0,
        "width": 304,
        "height": 114
      },
      "tileFilter": {
        "timeframe": "-1h"
      },
      "assignedEntities": [
        "1fc52003-8209-366a-8b61-84991b8cf779"
      ]
    },
    {
      "name": "Availability",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 152,
        "left": 304,
        "width": 304,
        "height": 114
      },
      "tileFilter": {
        "timeframe": "-24h to now"
      },
      "assignedEntities": [
        "1fc52003-8209-366a-8b61-84991b8cf779"
      ]
    },
    {
      "name": "Availability",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 152,
        "left": 608,
        "width": 304,
        "height": 114
      },
      "tileFilter": {
        "timeframe": "-7d to now"
      },
      "assignedEntities": [
        "1fc52003-8209-366a-8b61-84991b8cf779"
      ]
    },
    {
      "name": "Performance",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 0,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": "-1h"
      },
      "assignedEntities": [
        "2f2f4f74-0279-3e15-91e7-eedcebe5ae07"
      ]
    },
    {
      "name": "Performance",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 304,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": "-24h to now"
      },
      "assignedEntities": [
        "2f2f4f74-0279-3e15-91e7-eedcebe5ae07"
      ]
    },
    {
      "name": "Performance",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 608,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": "-7d to now"
      },
      "assignedEntities": [
        "2f2f4f74-0279-3e15-91e7-eedcebe5ae07"
      ]
    },
    {
      "name": "Last 30 days",
      "tileType": "DATA_EXPLORER",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 912,
        "width": 532,
        "height": 190
      },
      "tileFilter": {
        "timeframe": "-30d to now"
      },
      "customName": "Data explorer results",
      "queries": [
        {
          "id": "A",
          "timeAggregation": "DEFAULT",
          "splitBy": [],
          "metricSelector": "(builtin:synthetic.browser.availability.location.total:splitBy())",
          "enabled": true
        }
      ],
      "visualConfig": {
        "type": "GRAPH_CHART",
        "global": {
          "theme": "DEFAULT",
          "seriesType": "LINE"
        },
        "rules": [],
        "axes": {
          "xAxis": {
            "displayName": "",
            "visible": true
          },
          "yAxes": [
            {
              "displayName": "",
              "visible": true,
              "min": "97.33",
              "max": "100",
              "position": "LEFT",
              "queryIds": [
                "A"
              ],
              "defaultAxis": true
            }
          ]
        },
        "heatmapSettings": {},
        "thresholds": [
          {
            "axisTarget": "LEFT",
            "rules": [
              {
                "value": 99.99,
                "color": "#7dc540"
              },
              {
                "value": 99.98,
                "color": "#f5d30f"
              },
              {
                "value": 0,
                "color": "#dc172a"
              }
            ],
            "visible": true
          }
        ],
        "tableSettings": {},
        "graphChartSettings": {
          "connectNulls": false
        }
      }
    },
    {
      "name": "Last 30 days",
      "tileType": "DATA_EXPLORER",
      "configured": true,
      "bounds": {
        "top": 266,
        "left": 912,
        "width": 532,
        "height": 228
      },
      "tileFilter": {
        "timeframe": "-30d to now"
      },
      "customName": "Data explorer results",
      "queries": [
        {
          "id": "A",
          "timeAggregation": "DEFAULT",
          "metricSelector": "(100)*(calc:service.tenant.responsetime.count.faster500ms:splitBy())/(builtin:service.requestCount.server:splitBy())",
          "enabled": true
        }
      ],
      "visualConfig": {
        "type": "GRAPH_CHART",
        "global": {
          "theme": "DEFAULT",
          "seriesType": "LINE"
        },
        "rules": [],
        "axes": {
          "xAxis": {
            "displayName": "",
            "visible": true
          },
          "yAxes": [
            {
              "displayName": "",
              "visible": true,
              "min": "97.33",
              "max": "100",
              "position": "LEFT",
              "queryIds": [
                "A"
              ],
              "defaultAxis": true
            }
          ]
        },
        "heatmapSettings": {},
        "thresholds": [
          {
            "axisTarget": "LEFT",
            "rules": [
              {
                "value": 99.99,
                "color": "#7dc540"
              },
              {
                "value": 99.98,
                "color": "#f5d30f"
              },
              {
                "value": 0,
                "color": "#dc172a"
              }
            ],
            "visible": true
          }
        ],
        "tableSettings": {},
        "graphChartSettings": {
          "connectNulls": false
        }
      }
    },
    {
      "name": "Availability",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 0,
        "width": 912,
        "height": 38
      },
      "tileFilter": {}
    },
    {
      "name": "Performance (% faster than 500ms)",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 266,
        "left": 0,
        "width": 912,
        "height": 38
      },
      "tileFilter": {}
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 0,
        "width": 608,
        "height": 76
      },
      "tileFilter": {},
      "markdown": "## Service Level Objectives for tnt-comp-svc\nTODO: Change MZ, select your SLOs, add your name & tag"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 114,
        "left": 0,
        "width": 304,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Current (last hour)"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 114,
        "left": 304,
        "width": 304,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Last 24h"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 114,
        "left": 608,
        "width": 304,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Last 7 days"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 304,
        "left": 0,
        "width": 304,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Current (last hour)"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 304,
        "left": 304,
        "width": 304,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Last 24h"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 304,
        "left": 608,
        "width": 304,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Last 7 days"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 608,
        "width": 608,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Additional links: [Release management](/ui/releases), [Release validation](https://keptn.'${DOMAIN}'/bridge/dashboard)"
    }
  ]
}'