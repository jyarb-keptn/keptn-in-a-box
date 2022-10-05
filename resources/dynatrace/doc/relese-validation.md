## Setup for release validation demo

1. Create an API token with: 
  * `Write settings`
  * `Access problem and event feed, metrics, and topology`
  * `Write configuration`

2. Create custom metric `custom:releasevalidationscore` using the following curl: 

```
curl -X PUT \
  https://wna10783.dev.dynatracelabs.com/api/v1/timeseries/custom:releasevalidationscore \
  -H 'Authorization: Api-Token xxxxxxxxx' \
  -H 'Content-Type: application/json' \
  -d '{
    "timeseriesId": "custom:releasevalidationscore",
    "displayName": "Release Validation Score",
    "dimensions": ["Service", "Stage", "Project", "Version", "BuildId", "Result", "Score", "EvaluationTime"],
    "aggregationTypes": ["AVG", "SUM", "MIN", "MAX"],
    "unit": "Score",
    "filter": "CUSTOM",
    "detailedSource": "API",
    "types": ["test"],
    "warnings": []
}'
```

3. Create a CA secret in <envid>.cloudautomation.live.dynatrace.com: 
   * name: dynatrace-metric-ingest
   * scope: keptn-webhook-service
   * api-token: Api-Token (including value from step 0)


4. Create a Webhook in Cloud Automation which sends data points from every `sh.keptn.event.evaluation.finished` to demo.live: 

Example:
```
curl -X POST \
  https://wna10783.dev.dynatracelabs.com/api/v1/entity/infrastructure/custom/custom:releasevalidationscore \
  -H 'Authorization: Api-Token xxxxxxxxx' \
  -H 'Content-Type: application/json' \
  -d '{
    "type": "test",
    "series": [
        {
            "timeseriesId": "custom:releasevalidationscore",
            "dimensions": {
                "Service": "frontend",
                "Stage": "staging",
                "Project": "hipstershop",
                "Version": "1234",
                "BuildId": "1234",
                "Result": "pass",
                "Score": 80,
                "EvaluationTime": "2022-06-20T14:37:26.802125245Z"
            },
            "dataPoints": [
                [ 1657641682114, 80 ]
            ]
        }
    ]
}'
```

Webhook:
* Method: POST
* Custom header:
  * Authorization: Api-Token [reference to secret.api-token]
  * Content-type: application/json
* Webhook payload:
```
{
    "type": "test",
    "series": [
        {
            "timeseriesId": "custom:releasevalidationscore",
            "dimensions": {
                "Service": "{{.data.service}}",
                "Stage": "{{.data.stage}}",
                "Project": "{{.data.project}}",
                "Version": "{{.data.labels.version}}",
                "BuildId": "{{.data.labels.buildId}}",
                "Result": "{{.data.evaluation.result}}",
                "Score": {{.data.evaluation.score}},
                "EvaluationTime": "{{.time}}"
            },
            "dataPoints": [
                [ {{.data.labels.evaltime}}, {{.data.evaluation.score}} ]
            ]
        }
    ]
}
```

5. Update of chron jobs to trigger a sequence with the labels:
  * `evaltime` Value = date +%s%3N
  * `buildId` Value = date +%m%d%H%M
  * `version` value = `image version` --> v1.1, v1.6, v2.2

Example: evaltime=1657711941272,buildId=4711,version=v1.2


KeptnOrders
URL:
https://ibg73613.live.dynatrace.com/api/v1/entity/infrastructure/custom/custom:keptnordersreleasevalidationscore

Webhook:
* Method: POST
* Custom header:
  * Authorization: Api-Token [reference to secret.api-token]
  * Content-type: application/json
* Webhook payload:
```
{    "type": "test",    "series": [        {            "timeseriesId": "custom:keptnordersreleasevalidationscore",            "dimensions": {                "Service": "{{.data.service}}",                "Stage": "{{.data.stage}}",                "Project": "{{.data.project}}",                "Version": "{{.data.labels.version}}",                "BuildId": "{{.data.labels.buildId}}",                "Result": "{{.data.evaluation.result}}",                "Score": {{.data.evaluation.score}},                "EvaluationTime": "{{.time}}"            },            "dataPoints": [                [ {{.data.labels.evaltime}}, {{.data.evaluation.score}} ]            ]        }    ]}
```

Easytravel
URL:
https://ibg73613.live.dynatrace.com/api/v1/entity/infrastructure/custom/custom:releasevalidationscore

Webhook:
* Method: POST
* Custom header:
  * Authorization: Api-Token [reference to secret.api-token]
  * Content-type: application/json
* Webhook payload:
```
{    "type": "test",    "series": [        {            "timeseriesId": "custom:releasevalidationscore",            "dimensions": {                "Service": "{{.data.service}}",                "Stage": "{{.data.stage}}",                "Project": "{{.data.project}}",                "Version": "{{.data.labels.version}}",                "BuildId": "{{.data.labels.buildId}}",                "Result": "{{.data.evaluation.result}}",                "Score": {{.data.evaluation.score}},                "EvaluationTime": "{{.time}}"            },            "dataPoints": [                [ {{.data.labels.evaltime}}, {{.data.evaluation.score}} ]            ]        }    ]}
```
