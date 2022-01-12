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
    "name": "KQG;project=sockshop;stage=staging;service=carts",
    "shared": false,
    "owner": "'${OWNER}'",
    "dashboardFilter": {
      "timeframe": "-30m",
      "managementZone": {
        "id": "-5147804955159750385",
        "name": "Keptn: sockshop staging"
      }
    },
    "tags": [
      "kqg",
      "carts",
      "staging",
      "sockshop"
    ]
  },
  "tiles": [
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 874,
        "left": 760,
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 114,
        "left": 380,
        "width": 1140,
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
        "top": 418,
        "left": 0,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response time (P95);sli=svc_rt_p95;pass=<+10%,<600",
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 646,
        "left": 0,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response time (P90);sli=svc_rt_p90;pass=<+10%,<550",
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 874,
        "left": 0,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response time (P50);sli=svc_rt_p50;pass=<+10%,<500",
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 380,
        "left": 0,
        "width": 380,
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
        "top": 380,
        "left": 1140,
        "width": 380,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "Host-based (SLI/SLO)"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 760,
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
        "top": 646,
        "left": 760,
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 418,
        "left": 760,
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 380,
        "left": 380,
        "width": 380,
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
        "top": 418,
        "left": 380,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Failure Rate (Avg);sli=svc_fr;pass=<+10%,<2",
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 646,
        "left": 380,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Throughput (per min);sli=svc_tp_min;pass=<+10%,<200",
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "top": 418,
        "left": 1140,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Host CPU %;sli=host_cpu;pass=<50;warning=<70;key=false",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:host.cpu.usage",
              "aggregation": "AVG",
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 646,
        "left": 1140,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Host Memory used %;sli=host_mem;pass=<85;warning=<95;key=false",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:host.mem.usage",
              "aggregation": "AVG",
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 874,
        "left": 1140,
        "width": 380,
        "height": 228
      },
      "tileFilter": {},
      "filterConfig": {
        "type": "MIXED",
        "customName": "Host Disk Queue Length (max);sli=host_disk_queue;pass=<=5;warning=<6;key=false",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "builtin:host.disk.queueLength",
              "aggregation": "MAX",
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 874,
        "left": 380,
        "width": 380,
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
              "keptn_service:carts",
              "keptn_project:sockshop"
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
        "width": 1520,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "## Automated Release Validation based on Staging SLOs, Dynatrace detected problems and leading indicators"
    },
    {
      "name": "Service-level objective",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 152,
        "left": 0,
        "width": 380,
        "height": 152
      },
      "tileFilter": {
        "timeframe": "-7d to now"
      },
      "assignedEntities": [
        "1310f0f4-95d7-389e-afb9-f19001abb50b"
      ]
    },
    {
      "name": "Problems",
      "tileType": "OPEN_PROBLEMS",
      "configured": true,
      "bounds": {
        "top": 152,
        "left": 760,
        "width": 152,
        "height": 152
      },
      "tileFilter": {}
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 342,
        "left": 0,
        "width": 1520,
        "height": 38
      },
      "tileFilter": {},
      "markdown": "**Additional important SLIs & SLOs to validate a healthy staging to production deployment of your app**"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 114,
        "left": 0,
        "width": 380,
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
        "width": 1520,
        "height": 76
      },
      "tileFilter": {},
      "markdown": "This dashboard will automatically be analyzed as part of your staging to production deployment automation.\nTo see whats currently deployed check the [Releases Overview](/ui/releases). For all individual check out [Cloud Automation Heatmaps](https://keptn.192.168.3.91.nip.io/bridge)\n\nTODO: Clone dashboard, select your Management Zone, Add your relevant SLO, replace xxxx with your tenant name"
    },
    {
      "name": "Service-level objective",
      "tileType": "SLO",
      "configured": true,
      "bounds": {
        "top": 152,
        "left": 380,
        "width": 380,
        "height": 152
      },
      "tileFilter": {
        "timeframe": "-30m"
      },
      "assignedEntities": [
        "803119dd-02e7-3be7-a0ba-8908b64c6bcf"
      ]
    }
  ]
}'