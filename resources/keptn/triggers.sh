#!/bin/bash

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=easytravel-backend --timeframe=30m --labels=buildId=3,executedBy=manual

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=frontend --timeframe=30m --labels=buildId=5,executedBy=manual

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=check --timeframe=30m --labels=buildId=5,executedBy=manual

keptn trigger evaluation --project=sockshop --stage=staging --service=carts --timeframe=30m --labels=buildId=5,executedBy=manual
