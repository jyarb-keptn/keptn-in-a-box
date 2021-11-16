#!/bin/bash

DYNATRACE_TENANT=https://${DT_TENANTID}
DYNATRACE_ENDPOINT=${DYNATRACE_TENANT}/api/config/v1/dashboards
DYNATRACE_TOKEN=${DT_APITOKEN}

echo "DYNATRACE_ENDPOINT: ${DYNATRACE_ENDPOINT}"
echo "DYNATRACE_TOKEN: ${DYNATRACE_TOKEN}"

KEPTN_ENDPOINT=http://keptn.${KEPTN_DOMAIN}
KEPTN_PROJECT=sockshop
KEPTN_SERVICE=carts
KEPTN_STAGE=staging
KEPTN_BRIDGE_PROJECT=${KEPTN_ENDPOINT}/bridge/project/${KEPTN_PROJECT}

echo "KEPTN_ENDPOINT: ${KEPTN_ENDPOINT}"

export DYNATRACE_TENANT=${DYNATRACE_TENANT}
export DYNATRACE_ENDPOINT=${DYNATRACE_TENANT}/api/config/v1/dashboards
export DYNATRACE_TOKEN=${DYNATRACE_TOKEN}

export KEPTN_ENDPOINT=${KEPTN_ENDPOINT}
export KEPTN_PROJECT=${KEPTN_PROJECT}
export KEPTN_SERVICE=${KEPTN_SERVICE}
export KEPTN_STAGE=${KEPTN_STAGE}
export KEPTN_BRIDGE_PROJECT=${KEPTN_ENDPOINT}/bridge/project/${KEPTN_PROJECT}

##curl -X POST  ${DYNATRACE_ENDPOINT} -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token ${DYNATRACE_TOKEN}" -H "Content-Type: application/json; charset=utf-8" -d "{\"dashboardMetadata\":{\"name\":\"KQG;project=${KEPTN_PROJECT};service=${KEPTN_SERVICE};stage=${KEPTN_STAGE}\",\"shared\":false,\"owner\":\"\",\"sharingDetails\":{\"linkShared\":true,\"published\":false},\"dashboardFilter\":{\"timeframe\":\"\"}},\"tiles\":[{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":646,\"left\":760,\"width\":418,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Worker Process Count (Avg);sli=proc_count;\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:tech.generic.processCount\",\"aggregation\":\"AVG\",\"type\":\"LINE\",\"entityType\":\"PROCESS_GROUP_INSTANCE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":114,\"left\":0,\"width\":2052,\"height\":38},\"tileFilter\":{},\"markdown\":\"KQG.Total.Pass=90%;KQG.Total.Warning=70%;KQG.Compare.WithScore=pass;KQG.Compare.Results=1;KQG.Compare.Function=avg\"},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":190,\"left\":0,\"width\":380,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Response time (P95);sli=svc_rt_p95;pass=<+10%,<600\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:service.response.time\",\"aggregation\":\"PERCENTILE\",\"percentile\":95,\"type\":\"LINE\",\"entityType\":\"SERVICE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":418,\"left\":0,\"width\":380,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Response time (P90);sli=svc_rt_p90;pass=<+10%,<550\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:service.response.time\",\"aggregation\":\"PERCENTILE\",\"percentile\":90,\"type\":\"LINE\",\"entityType\":\"SERVICE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":646,\"left\":0,\"width\":380,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Response time (P50);sli=svc_rt_p50;pass=<+10%,<500\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:service.response.time\",\"aggregation\":\"PERCENTILE\",\"percentile\":50,\"type\":\"LINE\",\"entityType\":\"SERVICE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":152,\"left\":0,\"width\":380,\"height\":38},\"tileFilter\":{},\"markdown\":\"## Service Performance (SLI/SLO)\"},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":152,\"left\":1178,\"width\":418,\"height\":38},\"tileFilter\":{},\"markdown\":\"## Host-based (SLI/SLO)\"},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":152,\"left\":760,\"width\":418,\"height\":38},\"tileFilter\":{},\"markdown\":\"## Process Metrics (SLI/SLO)\"},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":418,\"left\":760,\"width\":418,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Process Memory;sli=process_memory\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:tech.generic.mem.workingSetSize\",\"aggregation\":\"AVG\",\"type\":\"LINE\",\"entityType\":\"PROCESS_GROUP_INSTANCE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":190,\"left\":760,\"width\":418,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Process CPU;sli=process_cpu;pass=<20;warning=<50;key=false\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:tech.generic.cpu.usage\",\"aggregation\":\"AVG\",\"type\":\"LINE\",\"entityType\":\"PROCESS_GROUP_INSTANCE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":152,\"left\":380,\"width\":380,\"height\":38},\"tileFilter\":{},\"markdown\":\"## Service Errors & Throughput (SLI/SLO)\"},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":190,\"left\":380,\"width\":380,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Failure Rate (Avg);sli=svc_fr;pass=<+10%,<2\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:service.errors.server.rate\",\"aggregation\":\"AVG\",\"type\":\"LINE\",\"entityType\":\"SERVICE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":418,\"left\":380,\"width\":380,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Throughput (per min);sli=svc_tp_min;pass=<+10%,<200\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:service.requestCount.total\",\"aggregation\":\"NONE\",\"type\":\"LINE\",\"entityType\":\"SERVICE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"MINUTE\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":152,\"left\":1596,\"width\":456,\"height\":38},\"tileFilter\":{},\"markdown\":\"## Test Transaction (SLI/SLO)\"},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":190,\"left\":1178,\"width\":418,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Host CPU %;sli=host_cpu;pass=<20;warning=<50;key=false\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:host.cpu.usage\",\"aggregation\":\"AVG\",\"type\":\"LINE\",\"entityType\":\"HOST\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":418,\"left\":1178,\"width\":418,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Host Memory used %;sli=host_mem;pass=<20;warning=<50;key=false\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:host.mem.usage\",\"aggregation\":\"AVG\",\"type\":\"LINE\",\"entityType\":\"HOST\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":646,\"left\":1178,\"width\":418,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Host Disk Queue Length (max);sli=host_disk_queue;pass=<=0;warning=<1;key=false\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:host.disk.queueLength\",\"aggregation\":\"MAX\",\"type\":\"LINE\",\"entityType\":\"HOST\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"TOTAL\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Custom chart\",\"tileType\":\"CUSTOM_CHARTING\",\"configured\":true,\"bounds\":{\"top\":646,\"left\":380,\"width\":380,\"height\":228},\"tileFilter\":{},\"filterConfig\":{\"type\":\"MIXED\",\"customName\":\"Calls to backend services (per min);sli=svc2svc_calls;\",\"defaultName\":\"Custom chart\",\"chartConfig\":{\"legendShown\":true,\"type\":\"SINGLE_VALUE\",\"series\":[{\"metric\":\"builtin:service.nonDbChildCallCount\",\"aggregation\":\"NONE\",\"type\":\"LINE\",\"entityType\":\"SERVICE\",\"dimensions\":[],\"sortAscending\":false,\"sortColumn\":true,\"aggregationRate\":\"MINUTE\"}],\"resultMetadata\":{}},\"filtersPerEntityType\":{}}},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":190,\"left\":1596,\"width\":456,\"height\":152},\"tileFilter\":{},\"markdown\":\"## Extend with Test Transactions\\n\\n\\nFollow the best practices around SRE-driven Performance Engineering as described in this [blog](https://www.dynatrace.com/news/blog/guide-to-automated-sre-driven-performance-engineering-analysis/)\\n\\nThis will allow you to add metrics per test or business transaction.\"},{\"name\":\"Markdown\",\"tileType\":\"MARKDOWN\",\"configured\":true,\"bounds\":{\"top\":0,\"left\":0,\"width\":2052,\"height\":114},\"tileFilter\":{},\"markdown\":\"## Welcome to your first SLI/SLO-based Quality Gate Dashboard - view results in your [Keptn Bridge](${KEPTN_BRIDGE_PROJECT})\\n \\nThis default dashboard includes a set of base metrics (SLIs) that produce values in any Dynatrace deployment. \\nUse this to make yourself familiar with defining your own SLIs (by adding more custom charts) and how to define SLOs (as part of the chart title) for every metric.\\nThis default chart does not split by metric dimensions such as service, process, or host; however, splitting is supported by Keptn and is encouraged.\\nFor more best practices on how to create these SLI/SLO dashboards please have a look at the [Dynatrace-SLI-Service readme](https://github.com/keptn-contrib/dynatrace-sli-service).\"}]}"

kubectl create secret generic dynatrace-credentials-sockshop -n "keptn" --from-literal="DT_TENANT=$DYNATRACE_TENANT" --from-literal="DT_API_TOKEN=$DYNATRACE_TOKEN"

cat > dynatrace.conf.yaml << EOF
---
spec_version: '0.1.0'
dtCreds: dynatrace-credentials-sockshop
dashboard: query

EOF

keptn add-resource --project=sockshop --stage=staging --resource=./dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml

# Use to make sure dynatrace-service is set to proper version
helm upgrade dynatrace-service -n keptn https://github.com/keptn-contrib/dynatrace-service/releases/download/0.17.0/dynatrace-service-0.17.0.tgz
