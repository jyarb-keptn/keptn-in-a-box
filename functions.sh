#!/bin/bash
# This file contains the functions for installing Keptn-in-a-Box.
# Each function contains a boolean flag so the installations
# can be highly customized.
#
# TODO:
#
# ==================================================
#      ----- Components Versions -----             #
# ==================================================
KIAB_RELEASE="0.8.21"
# https://github.com/keptn/keptn
KEPTN_VERSION=0.19.3
HELM_SERVICE_VERSION=0.18.1
JMETER_SERVICE=0.18.1
OPERATOR_VERSION=v0.10.0
ISTIO_VERSION=1.15.3
CERTMANAGER_VERSION=1.6.1
# https://github.com/helm/helm/releases
HELM_VERSION=3.10.3
# https://github.com/keptn-contrib/dynatrace-service
KEPTN_DT_SERVICE_VERSION=0.25.0
# https://github.com/keptn-contrib/dynatrace-sli-service
KEPTN_DT_SLI_SERVICE_VERSION=0.12.1
# https://github.com/keptn/examples
KEPTN_EXAMPLES_REPO="https://github.com/keptn/examples.git"
KEPTN_EXAMPLES_BRANCH="0.15.0"
KEPTN_EXAMPLES_DIR="~/examples"
KEPTN_CATALOG_REPO="https://github.com/jyarb-keptn/overview.git"
KEPTN_CATALOG_BRANCH="0.8.7"
KEPTN_CATALOG_DIR="~/overview"
TEASER_IMAGE="pcjeffmac/nginxacm:0.8.1"
KEPTN_BRIDGE_IMAGE="keptn/bridge2:0.8.0"
MICROK8S_CHANNEL="1.23/stable"
#KEPTN_IN_A_BOX_REPO="https://github.com/keptn-sandbox/keptn-in-a-box.git"
KEPTN_IN_A_BOX_REPO="https://github.com/jyarb-keptn/keptn-in-a-box.git"
KEPTN_IN_A_BOX_DIR="~/keptn-in-a-box"

USER_HOME_PATH="/home/dynatrace"
USER_KIAB_PATH="$USER_HOME_PATH/keptn-in-a-box"

# - The user to run the commands from. Will be overwritten when executing this shell with sudo, 
# this is just needed when spinning machines programatically and running the script with root without an interactive shell
USER="ubuntu"

# Comfortable function for setting the sudo user.
if [ -n "${SUDO_USER}" ]; then
  USER=$SUDO_USER
fi
echo "running sudo commands as $USER"

# Wrapper for runnig commands for the real owner and not as root
alias bashas="sudo -H -u ${USER} bash -c"
alias bashnu="sudo -H bash -c"
# Expand aliases for non-interactive shell
shopt -s expand_aliases

# ======================================================================
#       -------- Function boolean flags ----------                     #
#  Each function flag representas a function and will be evaluated     #
#  before execution.                                                   #
# ======================================================================
# If you add varibles here, dont forget the function definition and the priting in printFlags function.
verbose_mode=false
update_ubuntu=false
docker_install=false
microk8s_install=false
setup_proaliases=false
enable_k8dashboard=false
enable_registry=false
istio_install=false
helm_install=false
certmanager_install=false
certmanager_enable=false
keptn_install=false
keptn_install_qualitygates=false
keptn_examples_clone=false
resources_clone=false
hostalias=false
keptn_catalog_clone=false
git_deploy=false
git_env=false
git_migrate=false
dynatrace_savecredentials=false
dynatrace_configure_monitoring=false
dynatrace_install_dynakube=false
dynatrace_install_service=false
dynatrace_install_sli_service=false
dynatrace_activegate_install=false
dynatrace_configure_workloads=false
jenkins_deploy=false
keptn_bridge_eap=false
keptn_bridge_disable_login=false
keptndeploy_homepage=false
keptndemo_cartsload=false
keptndemo_unleash=false
keptndemo_unleash_configure=false
keptndemo_cartsonboard=false
keptndemo_catalogonboard=false
keptndemo_easytravelonboard=false
keptndemo_easytraveloadgen=false
keptndashboard_load=false
createMetrics=false
createApplications=false
expose_kubernetes_api=false
expose_kubernetes_dashboard=false
patch_kubernetes_dashboard=false
create_workshop_user=false
jmeter_install=false
keptnwebservice=false
sockshop_secret=false
post_flight=false
patch_config_service=false
dynatrace_project=false
QG_projects=false
# ======================================================================
#             ------- Installation Bundles  --------                   #
#  Each bundle has a set of modules (or functions) that will be        #
#  activated upon installation.                                        #
# ======================================================================
installationBundleDemo() {
  selected_bundle="installationBundleDemo"
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  setup_proaliases=true
  enable_k8dashboard=true
  istio_install=true
  helm_install=true
  certmanager_install=false
  certmanager_enable=false
  # install keptn
  keptn_install=true
  # clone repos
  keptn_examples_clone=true
  resources_clone=true
  keptn_catalog_clone=true
  hostalias=false
  # gitea
  git_deploy=true
  git_env=true
  git_migrate=false
  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true
  # install Dynatrace Operator
  dynatrace_install_dynakube=true
  # Dynatrace_service
  dynatrace_install_service=true
  #sli service is deprecated
  dynatrace_install_sli_service=false
  # Traditional ActiveGate
  dynatrace_activegate_install=false
  dynatrace_configure_workloads=true
  keptndeploy_homepage=true
  # unleash
  keptndemo_unleash=false
  keptndemo_unleash_configure=false
  # sockshop application
  keptndemo_cartsonboard=true
  keptndemo_cartsload=true
  # use for order application
  keptndemo_catalogonboard=true
  # use for easytravel
  keptndemo_easytravelonboard=true
  keptndemo_easytraveloadgen=true
  # dashboards for AIOPs
  keptndashboard_load=false
  # create custom metrics
  createMetrics=false
  createApplications=false
  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true
  patch_kubernetes_dashboard=true
  keptn_bridge_disable_login=true
  # By default no WorkshopUser will be created
  create_workshop_user=false
  jmeter_install=true
  dynatrace_project=true
  QG_projects=true
  keptnwebservice=true
  sockshop_secret=true
  post_flight=true
  patch_config_service=false
}

installationBundleWorkshop() {
  installationBundleDemo
  enable_registry=true
  create_workshop_user=true
  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true
  patch_kubernetes_dashboard=true
  keptn_bridge_disable_login=true

  selected_bundle="installationBundleWorkshop"
}

installationBundleAll() {
  # installation default
  installationBundleWorkshop

  enable_registry=true
  # plus all others
  certmanager_install=false
  certmanager_enable=false
  create_workshop_user=false
  keptn_bridge_disable_login=true

  jenkins_deploy=true

  selected_bundle="installationBundleAll"
}

installationBundleKeptnOnly() {
  # The minimal to have a full keptn working
  # with exposed istio and keptn over nginx
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  enable_k8dashboard=true

  setup_proaliases=true
  istio_install=true
  keptn_install=true
  helm_install=true
  keptn_examples_clone=true
  resources_clone=true

  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true
  dynatrace_install_dynakube=true

  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true

  keptndeploy_homepage=true

  selected_bundle="installationBundleKeptnOnly"
}

installationBundleKeptnQualityGates() {
  installationBundleKeptnOnly
  
  # We dont need istio nor helm
  istio_install=false
  helm_install=false

  # For the QualityGates we need both flags needs to be enabled
  keptn_install_qualitygates=true

  selected_bundle="installationBundleKeptnQualityGates"
}

installationBundlePerformanceAsAService() {
  installationBundleKeptnQualityGates

  # Jenkins needs Helm for the Chart to be installed
  helm_install=true
  jenkins_deploy=true

  selected_bundle="installationBundlePerformanceAsAService"
}

# ======================================================================
#          ------- Util Functions -------                              #
#  A set of util functions for logging, validating and                 #
#  executing commands.                                                 #
# ======================================================================
thickline="======================================================================"
halfline="============"
thinline="______________________________________________________________________"

setBashas() {
  # Wrapper for runnig commands for the real owner and not as root
  alias bashas="sudo -H -u ${USER} bash -c"
  # Wrapper to run as normal user
  alias bashnu="sudo -H bash -c"
  # Expand aliases for non-interactive shell
  shopt -s expand_aliases
}

# FUNCTIONS DECLARATIONS
timestamp() {
  date +"[%Y-%m-%d %H:%M:%S]"
}

printInfo() {
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |>->-> $1 <-<-<|"
}

printInfoSection() {
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |$thickline"
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |$halfline $1 $halfline"
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |$thinline"
}

printWarn() {
  echo "[Keptn-In-A-Box|WARN] $(timestamp) |x-x-> $1 <-x-x|"
}

printError() {
  echo "[Keptn-In-A-Box|ERROR] $(timestamp) |x-x-> $1 <-x-x|"
}

validateSudo() {
  if [[ $EUID -ne 0 ]]; then
    printError "Keptn-in-a-Box must be run with sudo rights. Exiting installation"
    exit 1
  fi
  printInfo "Keptn-in-a-Box installing with sudo rights:ok"
}


waitForAllPods() {
  # Function to filter by Namespace, default is ALL
  if [[ $# -eq 1 ]]; then
    namespace_filter="-n $1"
  else
    namespace_filter="--all-namespaces"
  fi
  RETRY=0
  RETRY_MAX=50
  # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
  CMD="bashas \"kubectl get pods $namespace_filter 2>&1 | grep -c -v -E '(Running|Completed|Terminating|STATUS)'\""
  printInfo "Checking and wait for all pods in \"$namespace_filter\" to run."
  while [[ $RETRY -lt $RETRY_MAX ]]; do
    pods_not_ok=$(eval "$CMD")
    if [[ "$pods_not_ok" == '0' ]]; then
      printInfo "All pods are running."
      break
    fi
    RETRY=$(($RETRY + 1))
    printInfo "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $pods_not_ok PoDs to finish or be in state Running ..."
    sleep 10
  done

  if [[ $RETRY == $RETRY_MAX ]]; then
    printError "Following pods are not still not running. Please check their events. Exiting installation..."
    bashas "kubectl get pods --field-selector=status.phase!=Running -A"
    exit 1
  fi
}

waitForAllPodsWithoutExit() {
  # Function to filter by Namespace, default is ALL
  if [[ $# -eq 1 ]]; then
    namespace_filter="-n $1"
  else
    namespace_filter="--all-namespaces"
  fi
  RETRY=0
  RETRY_MAX=60
  # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
  CMD="bashas \"kubectl get pods $namespace_filter 2>&1 | grep -c -v -E '(Running|Completed|Terminating|STATUS)'\""
  printInfo "Checking and wait for all pods in \"$namespace_filter\" to run."
  while [[ $RETRY -lt $RETRY_MAX ]]; do
    pods_not_ok=$(eval "$CMD")
    if [[ "$pods_not_ok" == '0' ]]; then
      printInfo "All pods are running."
      break
    fi
    RETRY=$(($RETRY + 1))
    printInfo "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $pods_not_ok PoDs to finish or be in state Running ..."
    sleep 10
  done

  if [[ $RETRY == $RETRY_MAX ]]; then
    printError "These Pods are still starting..."
    bashas "kubectl get pods --field-selector=status.phase!=Running -A"
  fi
}

waitForServersAvailability() {
  # expand function to wait for git curl 200 / eval RC
  if [[ $# -eq 1 ]]; then
    URL="$1"
  else
    printError "You need to define a URL to check a server's availability e.g. http://server.com/ "
    exit 1
  fi
  RETRY=0
  RETRY_MAX=24
  # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
  CMD="curl --write-out '%{http_code}' --silent --output /dev/null $URL"
  printInfo "Checking availability for URL  \"$URL\"."
  while [[ $RETRY -lt $RETRY_MAX ]]; do
    response=$(eval "$CMD")
    if [[ "$response" == '200' ]]; then
      printInfo "URL return 200."
      break
    fi
    RETRY=$(($RETRY + 1))
    printWarn "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $URL to be available... RC is $response"
    sleep 10
  done
  if [[ $RETRY == $RETRY_MAX ]]; then
    printError "URL $URL is still not available. Exiting..."
    #exit 1
  fi
}

enableVerbose() {
  if [ "$verbose_mode" = true ]; then
    printInfo "Activating verbose mode"
    set -x
  fi
}

printFileSystemUsage() {
  printInfoSection "File System usage"
  bashas 'df -h / --total'
}

printSystemInfo() {
  printInfoSection "Print System Information"
  printInfoSection "CPU Architecture"
  bashas 'lscpu'
  printInfoSection "Memory Information"
  bashas 'lsmem'
  printFileSystemUsage
}

# Function to convert 1K Blocks in IEC Formating (.e.g. 1M)
getDiskUsageInIec() {
  echo $(($1 * 1024)) | numfmt --to=iec
}

# Function to return the Available Usage of the Disk space in K Blocks (1024)
getUsedDiskSpace() {
  echo $(df / | tail -1 | awk '{print $3}')
}

# ======================================================================
#          ----- Installation Functions -------                        #
# The functions for installing the different modules and capabilities. #
# Some functions depend on each other, for understanding the order of  #
# execution see the function doInstallation() defined at the bottom    #
# ======================================================================
updateUbuntu() {
  if [ "$update_ubuntu" = true ]; then
    printInfoSection "Updating Ubuntu apt registry"
    apt update
  fi
}

dynatracePrintValidateCredentials() {
  printInfoSection "Printing Dynatrace Credentials"
  if [ -n "${TENANT}" ]; then
    printInfo "Shuffle the variables for name convention with Keptn & Dynatrace"
    PROTOCOL="https://"
    DT_TENANT=${TENANT#"$PROTOCOL"}
    printInfo "Cleaned tenant=$DT_TENANT"
    DT_API_TOKEN=$APITOKEN
    DT_PAAS_TOKEN=$PAASTOKEN
    printInfo "-------------------------------"
    printInfo "Dynatrace Tenant: $DT_TENANT"
    printInfo "Dynatrace API Token: $DT_API_TOKEN"
    printInfo "Dynatrace PaaS Token: $DT_PAAS_TOKEN"
  else
    printInfoSection "Dynatrace Variables not set, Dynatrace wont be installed"
    dynatrace_savecredentials=false
    dynatrace_configure_monitoring=false
    dynatrace_activegate_install=false
    dynatrace_configure_workloads=false
  fi
}

dockerInstall() {
  if [ "$docker_install" = true ]; then
    printInfoSection "Installing Docker and J Query"
    printInfo "Install J Query"
    apt install jq -y
    printInfo "Install Docker"
    apt install docker.io -y
    service docker start
    usermod -a -G docker $USER
  fi
}

setupProAliases() {
  if [ "$setup_proaliases" = true ]; then
    printInfoSection "Adding Bash and Kubectl Pro CLI aliases to .bash_aliases for user ubuntu and root "
    echo "
      # Alias for ease of use of the CLI
      alias las='ls -las' 
      alias hg='history | grep' 
      alias h='history' 
      alias vaml='vi -c \"set syntax:yaml\" -' 
      alias vson='vi -c \"set syntax:json\" -' 
      alias pg='ps -aux | grep' " >/root/.bash_aliases
    homedir=$(eval echo ~$USER)
    cp /root/.bash_aliases $homedir/.bash_aliases
  fi
}

setupMagicDomainPublicIp() {
  printInfoSection "Setting up the Domain"
  if [ -n "${DOMAIN}" ]; then
    printInfo "The following domain is defined: $DOMAIN"
    export DOMAIN
  else
    printInfo "No DOMAIN is defined, converting the public IP in a magic nip.io domain"
    PUBLIC_IP=$(curl -s ifconfig.me)
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    printInfo "Magic Domain: $DOMAIN"
  fi
  # Now we save the DOMAIN in a ConfigMap
  bashas "kubectl create configmap -n default domain --from-literal=domain=${DOMAIN}"  
}

microk8sInstall() {
  if [ "$microk8s_install" = true ]; then
    printInfoSection "Installing Microkubernetes with Kubernetes Version $MICROK8S_CHANNEL"
    snap install microk8s --channel=$MICROK8S_CHANNEL --classic

    printInfo "allowing the execution of priviledge pods "
    bash -c "echo \"--allow-privileged=true\" >> /var/snap/microk8s/current/args/kube-apiserver"

    printInfo "Add user $USER to microk8 usergroup"
    usermod -a -G microk8s $USER

    printInfo "Update IPTABLES, allow traffic for pods (internal and external) "
    iptables -P FORWARD ACCEPT
    #printInfo "Install iptables-persistent"
    #apt install iptables-persistent -y
    ufw allow in on cni0 && sudo ufw allow out on cni0
    ufw default allow routed

    printInfo "Add alias to Kubectl (Bash completion for kubectl is already enabled in microk8s)"
    snap alias microk8s.kubectl kubectl

    printInfo "Add Snap to the system wide environment."
    sed -i 's~/usr/bin:~/usr/bin:/snap/bin:~g' /etc/environment

    printInfo "Create kubectl file for the user"
    homedirectory=$(eval echo ~$USER)
    bashas "mkdir $homedirectory/.kube"
    bashas "microk8s.config > $homedirectory/.kube/config"
    bashas "chmod go-r $homedirectory/.kube/config"
  fi
}

microk8sStart() {
  printInfoSection "Starting Microk8s"
  bashas 'microk8s.start'
}

microk8sEnableBasic() {
  printInfoSection "Enable DNS, Storage, NGINX Ingress"
  if [ "$my_dns" = true ]; then
  printInfoSection "setting dns to $MYDNS"
  bashas 'microk8s.enable dns:$MYDNS'
  else
  bashas 'microk8s.enable dns'
  fi
  waitForAllPods
  bashas 'microk8s.enable storage'
  waitForAllPods
  bashas 'microk8s.enable ingress'
  waitForAllPods
  # experiment with enabling istio here.
  #bashas "microk8s.enable istio"
  #waitForAllPods
}

microk8sEnableDashboard() {
  if [ "$enable_k8dashboard" = true ]; then
    printInfoSection " Enable Kubernetes Dashboard"
    bashas 'microk8s.enable dashboard'
    waitForAllPods
  fi
}

microk8sEnableRegistry() {
  if [ "$enable_registry" = true ]; then
    printInfoSection "Enable own Docker Registry"
    bashas 'microk8s.enable registry'
    waitForAllPods
  fi
}

dynatraceActiveGateInstall() {
  if [ "$dynatrace_activegate_install" = true ]; then
    printInfoSection "Installation of Active Gate on $DT_TENANT"
    wget -nv -O activegate.sh "https://$DT_TENANT/api/v1/deployment/installer/gateway/unix/latest?Api-Token=$DT_PAAS_TOKEN&arch=x86&flavor=default"
    sh activegate.sh
    printInfo "removing ActiveGate installer."
    rm activegate.sh
  fi
}

istioInstall() {
  if [ "$istio_install" = true ]; then
    printInfoSection "Install istio $ISTIO_VERSION into /opt and add it to user/local/bin"
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
    printInfoSection "now move files and create symlink"
    mv istio-$ISTIO_VERSION /opt/istio-$ISTIO_VERSION
    chmod +x -R /opt/istio-$ISTIO_VERSION/
    ln -s /opt/istio-$ISTIO_VERSION/bin/istioctl /usr/local/bin/istioctl
    #bashas "echo 'y' | istioctl install --set meshConfig.outboundTrafficPolicy.mode=ALLOW_ANY"
    bashas "echo 'y' | istioctl install"
    bashas "kubectl label namespace default istio-injection=enabled"
    #bashas "echo 'y' | istioctl manifest apply --force"
    waitForAllPods
  fi
}

helmInstall() {
  if [ "$helm_install" = true ]; then
    printInfoSection "Installing HELM ${HELM_VERSION} & Client manually from binaries"
    wget -q -O helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
    tar -xvf helm.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm 

    printInfo "Adding Default repo for Helm"
    bashas "helm repo add stable https://charts.helm.sh/stable"
    printInfo "Adding Jenkins repo for Helm"
    bashas "helm repo add jenkins https://charts.jenkins.io"
    printInfo "Adding GiteaCharts for Helm"
    bashas "helm repo add gitea-charts https://dl.gitea.io/charts/"
    printInfo "Updating Helm Repository"
    bashas "helm repo update"
    bashas "helm version"
  fi
}

certmanagerInstall() {
  if [ "$certmanager_install" = true ]; then
    printInfoSection "Install CertManager $CERTMANAGER_VERSION with Email Account ($CERTMANAGER_EMAIL)"
    bashas "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v$CERTMANAGER_VERSION/cert-manager.yaml"
    waitForAllPods
  fi
}

certmanagerEnable() {
  if [ "$certmanager_enable" = true ]; then
    printInfoSection "Installing ClusterIssuer with HTTP Letsencrypt for ($CERTMANAGER_EMAIL)"

    #bashas "kubectl apply -f $KEPTN_IN_A_BOX_DIR/resources/ingress/clusterissuer.yaml"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-clusterissuer.sh $CERTMANAGER_EMAIL"
    waitForAllPods
    printInfo "Creating SSL Certificates with Let's encrypt for the exposed ingresses"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash add-ssl-certificates.sh"

    printInfoSection "Let's Encrypt Process in kubectl for CertManager"
    printInfo " For observing the creation of the certificates: \n
              kubectl describe clusterissuers.cert-manager.io -A
              kubectl describe issuers.cert-manager.io -A
              kubectl describe certificates.cert-manager.io -A
              kubectl describe certificaterequests.cert-manager.io -A
              kubectl describe challenges.acme.cert-manager.io -A
              kubectl describe orders.acme.cert-manager.io -A
              kubectl get events
              "
  fi
}

resourcesClone() {
  if [ "$resources_clone" = true ]; then
    printInfoSection "Clone Keptn-in-a-Box Resources in $KEPTN_IN_A_BOX_DIR"
    bashas "git clone --branch $KIAB_RELEASE $KEPTN_IN_A_BOX_REPO $KEPTN_IN_A_BOX_DIR --single-branch"
  fi
}

keptnExamplesClone() {
  if [ "$keptn_examples_clone" = true ]; then
    printInfoSection "Clone Keptn Exmaples $KEPTN_EXAMPLES_BRANCH"
    bashas "git clone --branch $KEPTN_EXAMPLES_BRANCH $KEPTN_EXAMPLES_REPO $KEPTN_EXAMPLES_DIR --single-branch"
  fi
}

keptnCatalogClone() {
  if [ "$keptn_catalog_clone" = true ]; then
    printInfoSection "Clone catalog $KEPTN_CATALOG_BRANCH"
    bashas "git clone --branch $KEPTN_CATALOG_BRANCH $KEPTN_CATALOG_REPO $KEPTN_CATALOG_DIR --single-branch"
  fi
}

dynatraceSaveCredentials() {
  if [ "$dynatrace_savecredentials" = true ]; then
    printInfoSection "Save Dynatrace credentials"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/ ; bash save-credentials.sh \"$DT_TENANT\" \"$APITOKEN\" \"$PAASTOKEN\""
  fi
}

hostAliasPod() {
  # TODO: Leaving in for now, but may need to remove, does not need to be installed.
  if [ "$hostalias" = true ]; then
    printInfoSection "Deploying HostAlias Pod"
    curl -o hostaliases-pod.yaml https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box/${KIAB_RELEASE}/resources/ingress/hostaliases-pod.yaml
    bashas "sudo kubectl apply -f hostaliases-pod.yaml"
    #bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash kubectl apply -f hostaliases-pod.yaml"
    #bashas "kubectl apply -f https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box.git/${KIAB_RELEASE}/resources/ingress/hostaliases-pod.yaml
  waitForAllPods
  fi
}

keptnInstallClient() {
  printInfoSection "Download and install Keptn CLI $KEPTN_VERSION"
  wget -q -O keptn.tar.gz "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/keptn-${KEPTN_VERSION}-linux-amd64.tar.gz"
  gunzip keptn.tar.gz
  tar -xvf keptn.tar
  chmod +x keptn-${KEPTN_VERSION}-linux-amd64
  mv keptn-${KEPTN_VERSION}-linux-amd64 /usr/local/bin/keptn
  printInfo "Remove keptn.tar"
  rm keptn.tar
}

keptnInstall() {
  if [ "$keptn_install" = true ]; then
    printInfoSection "install from https://github.com/keptn/keptn/releases"
    keptnInstallClient

    if [ "$keptn_install_qualitygates" = true ]; then
      printInfoSection "Install Keptn with Continuous Delivery UseCase (no Istio configurtion)"

      #bashas "echo 'y' | keptn install --use-case=continuous-delivery"
      bashas "helm repo add keptn https://charts.keptn.sh"
      bashas "helm install keptn keptn -n keptn --version ${KEPTN_VERSION} --repo=https://charts.keptn.sh --create-namespace --set=continuousDelivery.enabled=true"
      waitForAllPods keptn
      printInfoSection "Deploy Helm Service"
      #bashas "helm install jmeter-service https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/jmeter-service-${KEPTN_VERSION}.tgz -n keptn --create-namespace --wait"
      bashas "helm install helm-service https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/helm-service-${KEPTN_VERSION}.tgz -n keptn --create-namespace --wait"
      waitForAllPods keptn
    else
      ## -- Keptn Installation --
      printInfoSection "Install Keptn with Continuous Delivery UseCase"
      #bashas "echo 'y' | keptn install --use-case=continuous-delivery"
      bashas "helm repo add keptn https://charts.keptn.sh"
      bashas "helm install keptn keptn -n keptn --version ${KEPTN_VERSION} --repo=https://charts.keptn.sh --create-namespace --set=continuousDelivery.enabled=true"
      #bashas "helm upgrade keptn keptn --install -n keptn --create-namespace --set=ingress.enabled=true, ingress.annotations=<YOUR_ANNOTATIONS>, ingress.host=<YOUR_HOST>, ingress.path=<YOUR_PATH>, ingress.pathType=<YOUR_PATH_TYPE>, ingress.tls=<YOUR_TLS>"
      waitForAllPods keptn
      printInfoSection "Deploy Helm Service"
      #bashas "helm install jmeter-service https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/jmeter-service-${KEPTN_VERSION}.tgz -n keptn --create-namespace --wait"
      #bashas "helm install helm-service https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/helm-service-${KEPTN_VERSION}.tgz -n keptn --create-namespace --wait"
      bashas "helm install helm-service https://github.com/keptn-contrib/helm-service/releases/download/$HELM_SERVICE_VERSION/helm-service-$HELM_SERVICE_VERSION.tgz -n keptn"
      waitForAllPods keptn

      # Adding configuration for the IngressGW
      printInfoSection "Creating Public Gateway for Istio"
      bashas "cd $KEPTN_IN_A_BOX_DIR/resources/istio && kubectl apply -f public-gateway.yaml"
      #bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} sockshop-alt"
      
      #printInfoSection "Configuring Istio for Keptn"
      #bashas "kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${DOMAIN} --from-literal=ingress_port=80 --from-literal=ingress_protocol=http --from-literal=istio_gateway=ingressgateway.istio-system -oyaml --dry-run=client | kubectl replace -f -"
      INGRESS_HOSTNAME_SUFFIX=${DOMAIN}
      INGRESS_PORT=80
      INGRESS_PROTOCOL="http"      
      ISTIO_GATEWAY="public-gateway.istio-system"

      printInfoSection "Configuring Istio for Keptn"
      printInfoSection "INGRESS_INFO=${INGRESS_HOSTNAME_SUFFIX}:${INGRESS_PORT}:${INGRESS_PROTOCOL}:${ISTIO_GATEWAY}"
      bashas "kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME_SUFFIX} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} --from-literal=istio_gateway=${ISTIO_GATEWAY} -oyaml --dry-run=client | kubectl replace -f -"

      printInfo "Restart Keptn Helm Service"
      #bashas "kubectl delete pod -n keptn -l app.kubernetes.io/name=helm-service"
      bashas "kubectl delete pod -n keptn --selector=app.kubernetes.io/name=helm-service"
    fi
    
    printInfoSection "Routing for the Keptn Services via NGINX Ingress"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} api-keptn-ingress"
    waitForAllPods

    printInfoSection "Annotate and label namespace...."
    bashas "kubectl annotate namespace keptn keptn.sh/managed-by=keptn"
    bashas "kubectl label namespace keptn keptn.sh/managed-by=keptn"

    #We sleep for 15 seconds to give time the Ingress to be ready 
    sleep 15
    printInfoSection "Authenticate Keptn CLI"
    KEPTN_USER=$(kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_USERNAME}" | base64 --decode)
    KEPTN_ENDPOINT=https://$(kubectl get ing -n keptn api-keptn-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')/api
    KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    KEPTN_BRIDGE_URL=http://$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}')/bridge
    bashas "keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN"
    waitForAllPods
    bashas "keptn set config AutomaticVersionCheck false"
  fi
}

jmeterService() {
  if [ "$jmeter_install" = true ]; then
  printInfoSection "Deploy JMeter Service"
  #bashas "kubectl delete -n keptn deployment jmeter-service"
  #bashas "kubectl apply -f https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/${KIAB_RELEASE}/resources/keptn/jmeter-service.yaml -n keptn --record"
  #bashas "helm install jmeter-service https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/jmeter-service-${KEPTN_VERSION}.tgz -n keptn --create-namespace --wait"
  bashas "helm install jmeter-service https://github.com/keptn-contrib/jmeter-service/releases/download/${JMETER_SERVICE}/jmeter-service-${JMETER_SERVICE}.tgz -n keptn"
  waitForAllPods keptn
  fi
}

keptnDeployHomepage() {
  if [ "$keptndeploy_homepage" = true ]; then
    printInfoSection "Deploying the Autonomous Cloud (dynamic) Teaser with Pipeline overview $TEASER_IMAGE"
    bashas "kubectl -n default create deploy homepage --image=${TEASER_IMAGE}"
    bashas "kubectl -n default expose deploy homepage --port=80 --type=NodePort"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} homepage"
  fi
}

jenkinsDeploy() {
  if [ "$jenkins_deploy" = true ]; then
    printInfoSection "Deploying Jenkins via Helm. This Jenkins is configured and managed 'as code'"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/jenkins && bash deploy-jenkins.sh ${DOMAIN}"
    waitForAllPods jenkins
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} jenkins"
  fi
}

gitDeploy() {
  if [ "$git_deploy" = true ]; then
    printInfoSection "Deploying self-hosted GIT(ea) service via Helm."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/gitea && bash deploy-gitea.sh ${DOMAIN}"
    waitForAllPods git
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} gitea"
    GIT_SERVER="http://git.$DOMAIN"
    waitForServersAvailability ${GIT_SERVER}
  fi
}

setGitEnv() {
  if [ "$git_env" = true ]; then
    printInfoSection "Create Git token and Set Git Env variables..."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/gitea && bash git_env.sh ${DOMAIN}"
  fi
}

gitMigrate() {
  if [ "$git_migrate" = true ]; then
    printInfoSection "Migrating Keptn projects to a self-hosted GIT(ea) service."
    waitForAllPods git
    GIT_SERVER="http://git.$DOMAIN"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/gitea && bash update-git-keptn.sh ${DOMAIN}"
  fi
}

dynatraceConfigureMonitoring() {
  if [ "$dynatrace_configure_monitoring" = true ]; then
    printInfoSection "Installing and configuring Dynatrace OneAgent on the Cluster (via Keptn) for $DT_TENANT" 
    
    printInfo "Saving Credentials in dynatrace secret in keptn ns"
    bashas "kubectl -n keptn create secret generic dynatrace-credentials --from-literal=\"DT_TENANT=$DT_TENANT\" --from-literal=\"DT_API_TOKEN=$DT_API_TOKEN\"  --from-literal=\"KEPTN_API_URL=http://$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath={.spec.rules[0].host})/api\" --from-literal=\"KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)\" --from-literal=\"KEPTN_BRIDGE_URL=http://$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath={.spec.rules[0].host})/bridge\""
    printInfo "Create dynatrace secret"
    bashas "keptn create secret dynatrace --from-literal=\"DT_TENANT=$DT_TENANT\" --from-literal=\"DT_API_TOKEN=$DT_API_TOKEN\" --scope=dynatrace-service"
    
    if [ "$dynatrace_install_dynakube" = true ]; then
      printInfo "Deploying the Dynatrace Operator"
      bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && echo 'y' | bash deploy_dynakube.sh ${OPERATOR_VERSION}"
    else
      printInfo "Deploying the OneAgent Operator"
      bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && echo 'y' | bash deploy_operator.sh"    
    fi 
  fi
}

dynatraceServices() {
  if [ "$dynatrace_install_service" = true ]; then
    printInfoSection "set env variables"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash setenv.sh ${DOMAIN} ${AWS}"
    
    printInfoSection "KEPTN_ENDPOINT=$KEPTN_ENDPOINT"
    printInfoSection "KEPTN_BRIDGE_URL=$KEPTN_BRIDGE_URL"
    
    printInfo "Deploying the Dynatrace Service"
    #bashas "kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/$KEPTN_DT_SERVICE_VERSION/deploy/service.yaml -n keptn" 
    #bashas "helm upgrade --install dynatrace-service -n keptn https://github.com/keptn-contrib/dynatrace-service/releases/download/$KEPTN_DT_SERVICE_VERSION/dynatrace-service-$KEPTN_DT_SERVICE_VERSION.tgz"
    bashas "helm upgrade --install dynatrace-service -n keptn \
             https://github.com/keptn-contrib/dynatrace-service/releases/download/$KEPTN_DT_SERVICE_VERSION/dynatrace-service-$KEPTN_DT_SERVICE_VERSION.tgz \
  			--set dynatraceService.config.keptnApiUrl=$KEPTN_ENDPOINT \
  			--set dynatraceService.config.keptnBridgeUrl=$KEPTN_BRIDGE_URL \
  			--set dynatraceService.config.generateTaggingRules=true \
  			--set dynatraceService.config.generateProblemNotifications=false \
  			--set dynatraceService.config.generateManagementZones=true \
  			--set dynatraceService.config.generateDashboards=true \
  			--set dynatraceService.config.generateMetricEvents=true \
        --set distributor.image.tag=$KEPTN_VERSION"

    waitForAllPods keptn

    bashas "kubectl -n keptn get deployment dynatrace-service -o wide"
    bashas "kubectl -n keptn get pods -l run=dynatrace-service"

    bashas "keptn configure monitoring dynatrace"
  fi  
}

dynatraceSLIService() {
  if [ "$dynatrace_install_sli_service" = true ]; then
    printInfo "Setting up Dynatrace SLI provider in Keptn - depricated using new method"
    #bashas "kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/$KEPTN_DT_SLI_SERVICE_VERSION/deploy/service.yaml -n keptn"
    bashas "helm upgrade --install dynatrace-sli-service -n keptn https://github.com/keptn-contrib/dynatrace-sli-service/releases/download/$KEPTN_DT_SLI_SERVICE_VERSION/dynatrace-sli-service-$KEPTN_DT_SLI_SERVICE_VERSION.tgz"
    bashas "kubectl -n keptn get deployment dynatrace-sli-service -o wide"
    bashas "kubectl -n keptn get pods -l run=dynatrace-sli-service"
  fi
}

keptnBridgeEap() {
  if [ "$keptn_bridge_eap" = true ]; then
    printInfoSection "Keptn Bridge update to EAP"
    bashas "kubectl -n keptn set image deployment/bridge bridge=${KEPTN_BRIDGE_IMAGE} --record"
  fi
}

keptnBridgeDisableLogin() {
  if [ "$keptn_bridge_disable_login" = true ]; then
    printInfoSection "Keptn Bridge disabling Login"
    bashas "kubectl -n keptn delete secret bridge-credentials"
    bashas "kubectl -n keptn delete pods --selector=app.kubernetes.io/name=bridge"
  fi
}

keptndemoUnleash() {
  if [ "$keptndemo_unleash" = true ]; then
    printInfoSection "Prep Unleash Files for Project"
    bashas "cd $KEPTN_EXAMPLES_DIR/unleash-server/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/prepunleash.sh"
    printInfoSection "create unleash project"
    bashas "cd $KEPTN_EXAMPLES_DIR/unleash-server/ && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} unleash"
    printInfoSection "Deploy Unleash-Server"
    bashas "cd $KEPTN_EXAMPLES_DIR/unleash-server/ &&  bash $KEPTN_IN_A_BOX_DIR/resources/demo/deploy_unleashserver.sh"
    waitForAllPods unleash-dev
    printInfoSection "Expose Unleash-Server"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} unleash" 
    UNLEASH_SERVER="http://unleash.unleash-dev.$DOMAIN"
    waitForServersAvailability ${UNLEASH_SERVER}
  fi
}

keptndemoUnleashConfigure() {
  if [ "$keptndemo_unleash_configure" = true ]; then
    printInfoSection "Enable Feature Flags for Unleash and Configure Keptn for it"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/unleash_add_featureflags.sh ${UNLEASH_SERVER}"
    printInfoSection "No load generation will be created for running the experiment"
    printInfoSection "You can trigger the experiment manually here: https://tutorials.keptn.sh/tutorials/keptn-full-tour-dynatrace-08/#25"
  fi
}

dynatraceConfigureWorkloads() {
  if [ "$dynatrace_configure_workloads" = true ]; then
    printInfoSection "Configuring Dynatrace Workloads for the Cluster (via Dynatrace and K8 API)"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash configure-workloads.sh"
  fi
}

exposeK8Services() {
  if [ "$expose_kubernetes_api" = true ]; then
    printInfoSection "Exposing the Kubernetes Cluster API"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} k8-api"
  fi
  if [ "$expose_kubernetes_dashboard" = true ]; then
    printInfoSection "Exposing the Kubernetes Dashboard"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} k8-dashboard"
  fi
  if [ "$istio_install" = true ]; then
    printInfoSection "Exposing Istio Service Mesh as fallBack for nonmapped hosts (subdomains)"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} istio-ingress"
  fi
}

patchKubernetesDashboard() {
  if [ "$patch_kubernetes_dashboard" = true ]; then
    printInfoSection "Patching Kubernetes Dashboard, use only for learning and Workshops"
    echo "Skip Login in K8 Dashboard"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/misc && bash patch-kubernetes-dashboard.sh"
  fi
}

patchConfigService() {
  if [ "$patch_config_service" = true ]; then
    ## use to set host alias
    bashas "sudo kubectl apply -f https://raw.githubusercontent.com/dthotday-performance/keptn/${ALT_JMETER_SERVICE_BRANCH}/configuration-service/deploy/service.yaml -n keptn --record"
    waitForAllPods
  fi
}

keptndemoCartsonboard() {
  if [ "$keptndemo_cartsonboard" = true ]; then
    printInfoSection "Keptn onboarding Carts"
    printInfoSection "Prep jmeter files"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/prepfiles.sh"
    printInfoSection "Create Sockshop Project"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} sockshop"
    printInfoSection "Keptn onboarding Carts"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/onboard_carts.sh" 
    printInfoSection "Keptn onboarding Carts QualityGates"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/onboard_carts_qualitygates.sh"
    printInfoSection "Keptn deploy Carts"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/deploy_carts_0.sh"
    waitForAllPodsWithoutExit
    printInfoSection "Exposing the Onboarded Carts Application"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} sockshop"
  fi
}

keptndemoDeployCartsloadgenerator() {
  if [ "$keptndemo_cartsload" = true ]; then
    printInfoSection "Deploy Cartsload Generator"
    bashas "cd $KEPTN_CATALOG_DIR/demo_onbording/loadgen && bash $KEPTN_CATALOG_DIR/demo_onbording/loadgen/prepfiles.sh ${DOMAIN}"
    bashas "cd $KEPTN_CATALOG_DIR/demo_onbording/loadgen && kubectl apply -f cartsloadgen-base.yaml -n loadgen --record"
  fi
}

keptndemoCatalogonboard() {
  if [ "$keptndemo_catalogonboard" = true ]; then
    printInfoSection "Create tar files for helm..."
    bashas "cd $KEPTN_CATALOG_DIR/keptn-onboarding/ && bash create-helm-files.sh"
    printInfoSection "Create keptnorders Project"
    bashas "cd $KEPTN_CATALOG_DIR/keptn-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} keptnorders"
    printInfoSection "Keptn onboarding orders application"
    bashas "cd $KEPTN_CATALOG_DIR/keptn-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/catalog/onboard_catalog.sh && bash $KEPTN_IN_A_BOX_DIR/resources/catalog/onboard_catalog_qualitygates.sh"
    printInfoSection "start customer and catalog..."
    bashas "cd $KEPTN_CATALOG_DIR/keptn-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/catalog/deploy_catalog_0.1.sh"
    printInfoSection "start order and frontend..."
    waitForAllPodsWithoutExit
    bashas "cd $KEPTN_CATALOG_DIR/keptn-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/catalog/deploy_catalog_0.2.sh"
    waitForAllPodsWithoutExit
    #printInfoSection "Load remediation..."
    #bashas "cd $KEPTN_CATALOG_DIR/keptn-onboarding/ && bash loadRemediation.sh"
    printInfoSection "Exposing the Onboarded orders Application"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} keptnorders"
    printInfoSection "set env variables"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash setenv.sh ${DOMAIN}"
  fi
}

keptndemoEasytravelonboard() {
  if [ "$keptndemo_easytravelonboard" = true ]; then
    printInfoSection "Create tar files for helm..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash create-helm-files.sh"
    printInfoSection "Create easyTravel Project"
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} easytravel"
    printInfoSection "Keptn onboarding easytravel application"
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/easytravel/onboard_easytravel.sh"
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/easytravel/onboard_easytravel_qualitygates.sh"
    printInfoSection "deploy easytravel..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash $KEPTN_IN_A_BOX_DIR/resources/easytravel/deploy_0.sh"
    waitForAllPodsWithoutExit
    printInfoSection "Load remediation..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash loadRemediation.sh"
    printInfoSection "Exposing the Onboarded easytravel Application"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} easytravel"
    printInfoSection "set env variables"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash setenv.sh ${DOMAIN}"  
  fi
}

keptndemoEasytraveloadgen() {
  if [ "$keptndemo_easytraveloadgen" = true ]; then
    printInfoSection "easytrvel loadgen staging..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash preploadgen.sh ${DOMAIN} loadgen"
    printInfoSection "easytrvel loadgen production..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash preploadgen.sh ${DOMAIN} loadgen-prod"    
    printInfoSection "easytrvel angular loadgen staging..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash preploadgen.sh ${DOMAIN} loadgen-headless"
    printInfoSection "easytrvel angular loadgen production..."
    bashas "cd $KEPTN_CATALOG_DIR/easytravel-onboarding/ && bash preploadgen.sh ${DOMAIN} loadgen-headless-prod"    
  fi
}

metricCreation() {
  if [ "$createMetrics" = true ]; then
    printInfoSection "create request attributes for calculated metrics"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/createRequestAttributes.sh"
	sleep 5
    printInfoSection "create calculated metrics..."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/createTestStepCalculatedMetrics.sh CONTEXTLESS keptn_project keptnorders"
	sleep 5
	printInfoSection "create process group nameing rule..."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/createProcessGroupName.sh"
	sleep 5
	printInfoSection "create process group nameing rule..."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/createServiceName.sh"    
  fi
}

applicationCreation() {
  if [ "$createApplications" = true ]; then
    printInfoSection "create Application and Detection Rules..."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/createApplication.sh"   
  fi
}

loadKeptnDashboard() {
  if [ "$keptndashboard_load" = true ]; then
    printInfoSection "Keptn loading Dashboards"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load1.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load2.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load3.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load4.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load5.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"    
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load6.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load7.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load8.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
    sleep 2
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/dashboards && bash load9.sh ${DOMAIN} ${CERTMANAGER_EMAIL}"
  fi
}

loadDynatraceProject() {
 if [ "$dynatrace_project" = true ]; then
    printInfoSection "set env variables"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash setenv.sh ${DOMAIN}" 
    printInfoSection "create dynatrace project"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} dynatrace"
    printInfoSection "load dynatrace project"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/keptn/dynatrace-project.sh"
 fi
}

loadQGProjects() {
 if [ "$QG_projects" = true ]; then
    printInfoSection "set env variables"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash setenv.sh ${DOMAIN}" 
    printInfoSection "create QG projects"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} qualitygate"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} qualitygate-simpletest"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} performance"
    printInfoSection "upload performance qg shipyard.yaml"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/jenkins/pipelines/keptn/performanceqg/load_shipyard.sh"
 fi
}

loadKeptnWebService() {
 if [ "$keptnwebservice" = true ]; then
    printInfoSection "set env variables"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash setenv.sh ${DOMAIN}" 
    printInfoSection "load keptn web service"
    KEPTN_ENDPOINT=https://$(kubectl get ing -n keptn api-keptn-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')/api
    KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    printInfoSection "create webservices project"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptnwebservices && bash $KEPTN_IN_A_BOX_DIR/resources/gitea/git_post_env.sh ${DOMAIN} webservices"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptnwebservices && bash $KEPTN_IN_A_BOX_DIR/resources/keptnwebservices/deploykeptnwebservice.sh ${DOMAIN} ${KEPTN_API_TOKEN}"
    waitForAllPods webservices-dev
    printInfoSection "Exposing the keptnwebservice"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} keptnwebservice"    
 fi
}

setsockshopsecret() {
 if [ "$sockshop_secret" = true ]; then
    printInfoSection "create keptn secret for sockshop"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash setdbenv.sh ${DT_TENANT} ${DT_API_TOKEN} ${DOMAIN}"    
 fi
}

createWorkshopUser() {
  if [ "$create_workshop_user" = true ]; then
    printInfoSection "Creating Workshop User from user($USER) into($NEWUSER)"
    homedirectory=$(eval echo ~$USER)
    printInfo "copy home directories and configurations"
    cp -R $homedirectory /home/$NEWUSER
    printInfo "Create user"
    useradd -s /bin/bash -d /home/$NEWUSER -m -G sudo -p $(openssl passwd -1 $NEWPWD) $NEWUSER
    printInfo "Change diretores rights -r"
    chown -R $NEWUSER:$NEWUSER /home/$NEWUSER
    usermod -a -G docker $NEWUSER
    usermod -a -G microk8s $NEWUSER
    printInfo "Warning: allowing SSH passwordAuthentication into the sshd_config"
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart
  fi
}

postFlightWork() {
  if [ "$post_flight" = true ]; then    
    printInfoSection "PostFlight work for environment, project setup and secrets"
    bashas "chown -f -R ${USER} ~/.kube"
    #cp $KEPTN_IN_A_BOX_DIR/resources/misc/daemon.json /etc/docker/daemon.json
    #systemctl restart docker
    printInfo "Try to set host tags - if it fails - please run $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/hosttag.sh as sudo user"
    printInfo "USER-PATH=$USER_KIAB_PATH"
    printInfo "Create host tags"
    bashnu "cd ${USER_KIAB_PATH}/resources/dynatrace/scripts && bash $USER_KIAB_PATH/resources/dynatrace/scripts/hosttag.sh ${USER_KIAB_PATH}"
    printInfo "Create host tags fallback"
    bashas "cd ${KEPTN_IN_A_BOX_DIR}/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/hosttag.sh ${KEPTN_IN_A_BOX_DIR}"
    printInfo "Creates symbolic link to triggers command"
    bashas "cd $KEPTN_IN_A_BOX_DIR && bash setlinks.sh"
    printInfoSection "Set Kubernetes monitoring flags"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/setkubeflags.sh"
    printInfoSection "load project configs"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/keptn && bash $KEPTN_IN_A_BOX_DIR/resources/keptn/setprojectConf.sh"
    printInfoSection "create slack webhook secrets"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/webhook.sh"
    printInfoSection "create dynatrace-metric webhook secrets"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts && bash $KEPTN_IN_A_BOX_DIR/resources/dynatrace/scripts/setWebhookSecret.sh"
  fi
}

printInstalltime() {
  DURATION=$SECONDS
  printInfoSection "Installation complete :)"
  printInfo "It took $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds"
  printFileSystemUsage
  #DISK_USED=$(($DISK_FINAL - $DISK_INIT))
  #printInfo "Disk used size 1K Blocks: $DISK_USED"
  #printInfo "Disk used size in IEC Format: $(getDiskUsageInIec $DISK_USED)"

  printInfoSection "Keptn & Kubernetes Exposed Ingress Endpoints"
  printInfo "Below you'll find the adresses and the credentials to the exposed services."
  printInfo "We wish you a lot of fun in your Autonomous Cloud journey!"
  echo ""
  bashas "kubectl get ing -A"

  if [ "$keptn_bridge_disable_login" = false ]; then
    printInfoSection "Keptn Bridge Access"
    bashas "keptn configure bridge --output"
    echo ""
  fi

  if [ "$keptndemo_unleash" = true ]; then
    printInfoSection "Unleash-Server Access"
    printInfo "Username: keptn"
    printInfo "Password: keptn"
  fi

  if [ "$jenkins_deploy" = true ]; then
    printInfoSection "Jenkins-Server Access"
    printInfo "Username: keptn"
    printInfo "Password: keptn"
  fi

  if [ "$git_deploy" = true ]; then
    printInfoSection "Git-Server Access"
    bashas "bash $KEPTN_IN_A_BOX_DIR/resources/gitea/gitea-vars.sh ${DOMAIN}"
    printInfo "ApiToken to be found on $KEPTN_IN_A_BOX_DIR/resources/gitea/keptn-token.json"
    printInfo "For migrating keptn projects to your self-hosted git repository afterwards just execute the following function:"
    printInfo "cd $KEPTN_IN_A_BOX_DIR/resources/gitea/ && source ./gitea-functions.sh; createKeptnRepoManually {project-name}"
    printInfo "to make it easier, You can execute the helper script, cd $KEPTN_IN_A_BOX_DIR/resources/gitea then run ./update-git-keptn-post-flight.sh ${DOMAIN}"
    printInfo "This script will load any outstanding projects and update any existing projects."
  fi

  if [ "$create_workshop_user" = true ]; then
    printInfoSection "Workshop User Access (SSH Access)"
    printInfo "ssh ${NEWUSER}@${DOMAIN}"
    printInfo "Password: ${NEWPWD}"
  fi

  printInfoSection "Keptn in a Box $KIAB_RELEASE for keptn $KEPTN_VERSION installation finished."
  printInfoSection "Dynatrace Operator version $OPERATOR_VERSION"
  printInfoSection "dynatrace-service verison $KEPTN_DT_SERVICE_VERSION"
  printInfoSection "Use this URL to access your KIAB homepage http://${DOMAIN}"
  printInfo "Good luck in your Autonomous Cloud Journey!!"
  printInfo "If you faced an issue or just want to say hi, come by @ https://keptn.slack.com/"
}

printFlags() {
  printInfoSection "Function Flags values"
  for i in {selected_bundle,verbose_mode,update_ubuntu,docker_install,microk8s_install,setup_proaliases,enable_k8dashboard,enable_registry,istio_install,helm_install,hostalias,git_deploy,git_env,git_migrate,certmanager_install,keptn_install,keptn_install_qualitygates,keptn_examples_clone,resources_clone,keptn_catalog_clone,dynatrace_savecredentials,dynatrace_configure_monitoring,dynatrace_install_service,dynatrace_install_sli_service,dynatrace_activegate_install,dynatrace_configure_workloads,jenkins_deploy,keptn_bridge_disable_login,keptn_bridge_eap,keptndeploy_homepage,keptndemo_cartsload,keptndemo_unleash,keptndemo_unleash_configure,keptndemo_cartsonboard,keptndemo_catalogonboard,keptndemo_easytravelonboard,keptndemo_easytraveloadgen,jmeter_install,expose_kubernetes_api,expose_kubernetes_dashboard,patch_kubernetes_dashboard,certmanager_enable,keptnwebservice,sockshop_secret,create_workshop_user,keptndashboard_load,createMetrics,createApplications,dynatrace_project,QG_projects,post_flight,patch_config_service}; 
  do 
    echo "$i = ${!i}"
  done
}

# ======================================================================
#            ---- The Installation function -----                      #
#  The order of the subfunctions are defined in a sequencial order     #
#  since ones depend on another.                                       #
# ======================================================================
doInstallation() {
  echo ""
  printInfoSection "Init Installation at  $(date) by user $(whoami)"
  printInfo "Setting up Microk8s (SingleNode K8s Dev Cluster) with Keptn"
  echo ""
  # Record time of installation
  SECONDS=0

  printFlags
  
  echo ""
  validateSudo
  setBashas
  dynatracePrintValidateCredentials
  enableVerbose
  updateUbuntu
  setupProAliases
  dockerInstall
  microk8sInstall
  microk8sStart
  microk8sEnableBasic
  microk8sEnableDashboard
  microk8sEnableRegistry
  hostAliasPod
  dynatraceActiveGateInstall
  istioInstall
  helmInstall
  certmanagerInstall
  resourcesClone
  keptnExamplesClone
  keptnCatalogClone
  dynatraceSaveCredentials
  setupMagicDomainPublicIp
  exposeK8Services
  patchKubernetesDashboard

  keptnInstall
  dynatraceServices
  dynatraceSLIService  
  jmeterService 
  keptnDeployHomepage
  keptnBridgeEap
  keptnBridgeDisableLogin

  dynatraceConfigureMonitoring
  dynatraceConfigureWorkloads 

  jenkinsDeploy
  gitDeploy
  setGitEnv
  loadDynatraceProject
  loadQGProjects
  loadKeptnDashboard
  createWorkshopUser
  patchConfigService
  keptndemoUnleash
  keptndemoCartsonboard    
  keptndemoCatalogonboard 
  keptndemoEasytravelonboard
  applicationCreation
  loadKeptnWebService
  gitMigrate
  keptndemoUnleashConfigure
  keptndemoDeployCartsloadgenerator
  keptndemoEasytraveloadgen
  metricCreation
  certmanagerEnable
  setsockshopsecret
  postFlightWork

  DISK_FINAL=$(getUsedDiskSpace)
  printInstalltime
}

# When the functions are loaded in the Keptn-in-a-box Shell this message will be printed out.
printInfo "Keptn-in-a-Box installation functions loaded in the current shell"
