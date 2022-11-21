#!/bin/bash

# 
# Use this script to reset the environment
#
echo "Start Reset..."
KEPTN_IN_A_BOX_REPO="https://github.com/jyarb-keptn/keptn-in-a-box.git"
KIAB_RELEASE="0.8.20"
KIAB_FILE_REPO="https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/${KIAB_RELEASE}/keptn-in-a-box.sh"

sudo snap remove microk8s --purge

cd /opt/dynatrace/oneagent/agent
sudo ./uninstall.sh

cd /opt/dynatrace/gateway
sudo ./uninstall.sh

cd /var/lib
sudo rm -rf dynatrace

cd /opt
sudo rm -rf dynatrace

echo "Remove directories and files..."
cd ~
sudo rm -rf helm.tar.gz
sudo rm -rf keptn-in-a-box.sh
sudo rm -rf functions.sh
sudo rm -rf snap
sudo rm -rf linux-amd64
sudo rm -rf keptn-in-a-box
sudo rm -rf examples
sudo rm -rf overview
sudo rm -rf trigger.sh
cd ~
sudo rm -rf .keptn
sudo rm -rf .kube

sudo rm /tmp/install.log

sudo rm -rf /opt/istio-*
sudo rm /usr/local/bin/istioctl
sudo rm /usr/local/bin/keptn

curl -O $KIAB_FILE_REPO
chmod +x keptn-in-a-box.sh
echo "Reset Complete..."
