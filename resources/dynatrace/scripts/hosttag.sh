#!/bin/bash

HOMEDIR=$1

cp ${HOMEDIR}/resources/dynatrace/scripts/hostautotag.conf /var/lib/dynatrace/oneagent/agent/config/hostautotag.conf
