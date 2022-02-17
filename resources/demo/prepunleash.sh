#!/bin/bash -x

KEPTN_PREP_DIR="overview"
KEPTN_EXAMPLES_DIR="examples"

echo $HOME
echo "copy files...."

cp ${HOME}/${KEPTN_PREP_DIR}/demo_onbording/dynatrace.conf.yaml ${HOME}/${KEPTN_EXAMPLES_DIR}/unleash-server/dynatrace.conf.yaml

echo "file has been copied..."