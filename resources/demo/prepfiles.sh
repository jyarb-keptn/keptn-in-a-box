#!/bin/bash -x

KEPTN_PREP_DIR="overview"
KEPTN_EXAMPLES_DIR="examples"

echo $HOME
echo "moving files...."

# copy new format for metric indicators
cp ${HOME}/keptn-in-a-box/resources/demo/sli-config-dynatrace.yaml ${HOME}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/sli-config-dynatrace.yaml

#move files for jmeter
cp ${HOME}/${KEPTN_PREP_DIR}/demo_onbording/dev/carts/jmeter/load.jmx ${HOME}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/load.jmx
cp ${HOME}/${KEPTN_PREP_DIR}/demo_onbording/dev/carts/jmeter/basiccheck.jmx ${HOME}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/basiccheck.jmx

echo "validate port config parameters"
grep 'PORT' ${HOME}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/basiccheck.jmx
grep 'PORT' ${HOME}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/load.jmx
