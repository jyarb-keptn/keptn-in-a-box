#!/bin/bash

KIAB_PATH=$1

cp ${KIAB_PATH}/resources/dynatrace/scripts/hostautotag.conf /var/lib/dynatrace/oneagent/agent/config/hostautotag.conf
