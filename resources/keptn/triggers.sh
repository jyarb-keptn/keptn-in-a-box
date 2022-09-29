#!/bin/bash

evaldate=`date +%s%3N`
buildid=`date +%m%d%H%M`

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=www --timeframe=30m --labels=buildId=${buildid},version=2.0.0.3356,evaltime=${evaldate},executedBy=trigger

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=Auth2 --timeframe=30m --labels=buildId=${buildid},version=2.0.0.3356,evaltime=${evaldate},executedBy=trigger

keptn trigger evaluation --project=dynatrace --stage=quality-gate --service=check --timeframe=30m --labels=buildId=${buildid},version=2.0.0.3356,evaltime=${evaldate},executedBy=trigger

keptn trigger evaluation --project=sockshop --stage=staging --service=carts --timeframe=30m --labels=buildId=${buildid},version=0.12.1,evaltime=${evaldate},executedBy=trigger
