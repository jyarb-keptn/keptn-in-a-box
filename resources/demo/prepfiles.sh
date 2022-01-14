#!/bin/bash -x

KEPTN_PREP_DIR="overview"
KEPTN_EXAMPLES_DIR="examples"

HOMEDIR=$1

echo $HOMEDIR
echo "moving files...."

# copy new format for metric indicators
cp ${HOMEDIR}/keptn-in-a-box/resources/demo/sli-config-dynatrace.yaml ${HOMEDIR}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/sli-config-dynatrace.yaml

cp ${HOMEDIR}/${KEPTN_PREP_DIR}/demo_onbording/dynatrace.conf.yaml ${HOMEDIR}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/dynatrace.conf.yaml

#move files for jmeter
cp ${HOMEDIR}/${KEPTN_PREP_DIR}/demo_onbording/dev/carts/jmeter/load.jmx ${HOMEDIR}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/load.jmx
cp ${HOMEDIR}/${KEPTN_PREP_DIR}/demo_onbording/dev/carts/jmeter/basiccheck.jmx ${HOMEDIR}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/basiccheck.jmx

echo "validate port config parameters"
grep 'PORT' ${HOMEDIR}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/basiccheck.jmx
grep 'PORT' ${HOMEDIR}/${KEPTN_EXAMPLES_DIR}/onboarding-carts/jmeter/load.jmx
