#!/bin/bash

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=www --timeframe=30m --labels=buildId=3,executedBy=manual

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=Auth2 --timeframe=30m --labels=buildId=5,executedBy=manual
