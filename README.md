> **DISCLAIMER**: This project was developed for educational purposes only and is not complete, 
nor supported. It's publishment is only intended for helping others automate environments for delivering 
workshops with Keptn & Dynatrace. Even though the exposed endpoints of this cluster have valid SSL certificates 
generated with Cert-Manager and Let's Encrypt, does not mean the Box is secure.    

> ## ***🥼⚗ Spend more time innovating and less time configuring***

# Keptn-in-a-Box Enhanced (with Dynatrace Software Intelligence empowered) 🎁

:rotating_light: ALERT: This install uses keptn 0.11.3 :rotating_light:

Keptn-In-A-Box is part of the automation for delivering Autonomous Cloud Workshops with Dynatrace. This is not a tutorial but more an explanation of what the shell file set up for you on a plain Ubuntu image. 

A simple Bash script will set-up a fully functional Single Node Kubernetes Cluster with Dynatrace installed and Kubernetes Cluster, Cloud Applications and Events monitoring enabled. This script is used as [userdata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) when spinning up elastic compute images (ec2) in amazon web services, but it can run also manually in a Linux machine or VM with snap installed. The tested distro is  *Ubuntu Server 18.04 LTS & 20.04 LTS*
For spinning up instances automatically with AWS completely configured and set up, and also automating the creation and management of Dynatrace environments, take a look at this project- [Dynatrace - Rest Tenant Automation](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation) 

|Name | Version | Description | 
------------- | ------------- | ------------ |
| **kiab** | [main](https://github.com/jyarb-keptn/keptn-in-a-box/tree/main) | keptn 0.8.3 |
| **kiab** | [0.8.9](https://github.com/jyarb-keptn/keptn-in-a-box/tree/0.8.9) | keptn 0.11.3 |
| **kiab** | [0.8.8](https://github.com/jyarb-keptn/keptn-in-a-box/tree/0.8.8) | keptn 0.10.0 |
| **kiab** | [0.8.7](https://github.com/jyarb-keptn/keptn-in-a-box/tree/0.8.7) | keptn 0.9.2 |
| **kiab** | [0.8.1](https://github.com/jyarb-keptn/keptn-in-a-box/tree/0.8.1) | keptn 0.8.1 (stable)|
| **kiab** | [release-0.8pre](https://github.com/jyarb-keptn/keptn-in-a-box/tree/release-0.8pre) | experimental also pushes to main |

![#](doc/images/keptn-in-a-box-autonomous-cloud-devops.gif)

## 🥜Keptn-in-a-Box - Features in a Nutshell
- Update the ubuntu repository
- Installation of Docker (for building own Docker images)
- Installation of Microkubernetes
- Allow the Kube-API to run priviledged pods (necessary for deploying the FullStack Agent via Operator)
- Update IPTABLES: allowing traffic for pods internal and external
- Set up of useful BASH Aliases for working with the command line
- Enable autocompletion of Kubectl
- Installation of Dynatrace ActiveGate and configuration of [Cluster](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/connect-kubernetes-clusters-to-dynatrace/) and [Workload monitoring](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/monitor-workloads-kubernetes/)
- Installation of Istio 1.9.1 
- Installation of Helm Client
- Enabling own Docker Registry for the Cluster
- Convert the public IP in a (magic) domain ([nip.io](https://nip.io/)) for being able to expose all the needed services with subdomains.
- Routing of traffic to Istio-Ingressgateway via a Kubernetes NGINX Ingress using standard HTTP(S) ports 80 and 443. This way we dont need a public IP from the Cloud Provider
- Installation of Keptn (QualityGates also available)
- Expose the Keptn-Bridge Service
- Installation of Dynatrace OneAgent via Keptn
- Deployment of Jenkins preconfigured und managed as code
- Deployment of the Unleash-Server
- Onboard of the Sockshop-Carts Sample project
- Onboard of the keptnOrders project
- Onboard of the easytravel project
- Deployment of a cartsloadgenerator PoD
- Deployment of a Autonomous Cloud teaser home page with links to the pipeline, kubernetes api, keptn-bridge, keptn-api, jenkins 
- Creation of valid SSL certificates for the exposed endpoints with Certmanager and HTTPs Let's encrypt.
- Create a user account and copy the standard user (ubuntu on this case) with his own home directory (a replica) and allowing SSH connections with text password. Useful for spinning an army of workshop clusters. 

### 💻The Keptn-in-a-Box Bash installation

<table>
  <tr>
    <td>
    <p>
    The bash file is scripted in a modular fashion allowing you with  control flags to enable or disable the modules that you want to install in your box. This allows you to have a very slim cluster running keptn with the bare minimal resources or to have a full blown cluster with pretty much all the desired features and frameworks for your CI/CD pipelines and performance testings.
    <ol>
    <li><a href="keptn-in-a-box.sh">keptn-in-a-box.sh</a></li>
    <li><a href="functions.sh">functions.sh</a></li>
    </ol>  
    </p>
    </td>
    <td>
      <img src="doc/images/keptn-in-a-box.png" width="700px" title="Keptn-in-a-Box"> 
    </td>
  </tr>
</table>



## 📚Tutorial
For a step by step understanding of how Keptn-in-a-Box works and how to use it, take a look at the Keptn in a Box tutorial [https://tutorials.keptn.sh/tutorials/keptn-in-a-box/)](https://tutorials.keptn.sh/tutorials/keptn-in-a-box-07)
(This tutorial covers the base KIAB install)

## Prerequisites

- [Ubuntu](https://ubuntu.com/#download) with internet connection (tested on 18.04 LTS and 20.04 LTS)

#### (optional)
- [A Dynatrace Tenant](https://www.dynatrace.com/trial/) 
- AWS Account [Here you can get a free account](https://aws.amazon.com/free/)
- You will get the most out of it if your DOMAIN is configured and reachable either by Dynatrace SaaS or Dynatrace Managed.

## Repository Structure
```bash
─ doc                       doc folder.
─ keptn-in-a-box.sh         the executable (also where to define your variables)
─ functions.sh        		The definiton of functions and modules 
─ resources                 
  ├── cartsloadgenerator    Sources of the load container of the carts app
  ├── catalog               Scripts for Onboarding the keptnOrders app
  ├── easytravel            Scripts for Onboarding the easytravel app 
  ├── demo                  Scripts for Onboarding the Carts app  
  ├── dynatrace             Scripts for integrating with Dynatrace
  ├── homepage              Sources of the homepage for displaying the Autonomous Cloud teaser  
  ├── ingress               Files and logic for mapping, exposing the endpoints and services. Creation of Certificates.
  ├── istio                 istio config files  
  ├── jenkins               Deployment and configuration for Jenkins managed as code.
  ├── misc                  Miscelaneous (patch kubernetes dashboard)
  └── virtualservices       YAML files for virtualservices 
```

## 💾 Sizing

This section will give you an idea the nedded size for your Box. But it all depends on the modules you want to install and what is your goal and usecase.
The installer comes with 3 predefined modules: **minimal**, **default** and **full**. 

### 🕐 Installation time
From the testing in AWS minimal installation takes ~ 4 minutes to complete and full ~ 20 minutes. 

### AWS sizings for reference 
Below is a table for the sizing reference if you run a local VM or are virtualizing locally.

| **Size**   | **vCPUs** | **Memory (GiB)** |
| ---------- | --------- | ---------------- |
| t2.2xlarge | 8         | 32               |
| c4.4xlarge | 16        | 30               | (preferred for full)

### installationBundleKeptnOnly
The minimum required for running a Single Node Kubernetes cluster with keptn full features is a t2.medium (2 vCPU and 4 Gib of RAM) and 10 Gigabytes of disk space. If you feel frisky go for this size but the experience won't be the best. 

Adding more RAM and more CPUs will speed up things. Depending what you want to achieve. Also consider that you'll have available less than 2 Gigs of disk space. This is the available disk after a minimal installation.

```bash
df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        20G  5.8G   14G  30% /
```

### installationBundleDemo
The minimum required for running the default modules is t2.large with 13 Gigs of Disk space. We recommend 20 Gigs and t2.xlarge for the best experience.

### :white_check_mark: installationBundleAll
The minimum required for running the default modules is t2.2xlarge with 30 Gigs of Disk space. We recommend c4.4xlarge with 60 Gigs of Disk space for the best experience.

## :arrow_right: Setup and Configure AWS Instance.

1. Ubuntu 20.04 LTS is recommended.

1. Set the storage size to at least 60 GB.

1. Add a tag with key=Project and value=KIAB

1. Add a tag with Key=Name and Value=FirstName-LastName

1. Open Ports <br>
If you define security rules in the Cloud provider or on your datacenter, your instance needs to have the following ports accessible:

* 22/SSH
* 80/HTTP
* 443/HTTPS
* 8080/Custom
* 4200/Custom

### :arrow_right: Create Tokens
Next You will need to create the necessary tokens. 

How to [Create Tokens](#create-tokens)

Now you are ready to start the install process.

### :arrow_right: Get started in 1 - 2 - 3 - 4

### Run it in an available machine  (manually)

#### 1. Log in into  your Ubuntu image

If you use a authentication key
```bash
ssh -i "DevOps.pem" ubuntu@ec2-54-172-78-187.compute-1.amazonaws.com
```

#### 2. Get the script

```bash
curl -O https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.9/keptn-in-a-box.sh
```

> You can also specify a specific release like 'curl -O https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/${KIAB_RELEASE}/keptn-in-a-box.sh' the master branch will be pointing to the actual release.

#### 3. Change permissions on script.

```bash
chmod +x keptn-in-a-box.sh
```

#### 4. Execute the file with sudo rights.
```bash
sudo bash -c './keptn-in-a-box.sh'
```
#### 4.1 New execution method with flags. 
```
yes | sudo  bash -c './keptn-in-a-box.sh -t <TENANT> -a <APITOKEN> -p <PAASTOKEN> -e <UserEmail>'
```

The script will ask for the following inputs.

- Use the Dynatrace information for the inputs to the script:

	- TENANT="mytenant.live.dynatrace.com"
	- PAASTOKEN=myDynatracePaaSToken
	- APITOKEN=myDynatraceApiToken

     > for your tenent just use the folowing:
     >  *{your-domain}/e/{your-environment-id}* 
     > for managed or 
     > {your-environment-id}.live.dynatrace.com 
     > for SaaS.
     > You can also use 
     > {your-environment-id}.sprint.dynatracelabs.com
     > or a dev tenant if inclined.

	 > User Email should match your Dynatrace login to the tenant.
	 > if the User Email matches your login, then the Dashbaords will show
	 > up under your account in the Dynatrace UI.

```bash
Dynatrace Tenant ID []:
Dynatrace API Token: []:
Dynatrace PaaS Token: []:
User Email []:
```

answer **'y'** if the information is correct, then Press **enter**

And that was it! Yes that easy!  
This command will run the installation in a bash shell as sudo and send the job to the background. You will not see any output since stdout and stderr are piped to a logfile which is located by default in **/tmp/install.log** 

For inspecting the installation on realtime type:
```bash
less +F /tmp/install.log
```

Be patient, the deployment process will average ~20 min.

:white_check_mark: Now you can get the URL for your KIAB homepage.

<img src="doc/images/KIAB_info.png" width="500"/>

Just open a Browser with the IP.

### :arrow_right: Next Run A Pipeline

Click on **"Jenkins"**

1. First you will need to click "Install Suggested plugins"

<img src="doc/images/jenkins-install-plugins.png" width="400" height="300"/>

   You should then see a progress screen.

<img src="doc/images/jenkins-progress.png" width="400" height="300"/>

2. Now "Jenkins is ready", just click "start using jenkins".

<img src="doc/images/jenkins-ready.png" width="250"/>

3. Now we will kick off the Pipeline **01-deploy-order-application** to build out the application.

   Login to Jenkins with the following credentials

   * username = keptn
   * password = keptn

<img src="doc/images/Lab_1_Jenkins_Log_In.png" width="250"/>

   After selecting the pipeline click **"build"**

<img src="doc/images/Lab_1_deploy_order_application_1.png" width="500"/>

Now we can follow the next steps to review the Pipelines and understand the different scenerios.
Just follow the arrows.

## :white_check_mark: Understanding Demo Flows and the Deployment

### 1 - Review the Pipelines

:arrow_right: [Review Pipelines](#the-sample-pipelines)

### 2 - Review and understand the problem scenerios

:arrow_right: [Application Overview and Problem Scenerios](doc/index.md)

### 3 - Understanding and setup for Load Testing

:arrow_right: [Load Test Analysis Performance Issue](doc/index-2.md)

### 4 - SLO's and Test Analysis

:arrow_right: [SLOs and Load Test Analysis Error Issue](doc/index-3.md)

### 5 - PostFlight Git update

:arrow_right: [Upstream git](#post-flight-git)

### 6 - Available builds, problem patters and scenerios for Sockshop
:arrow_right: https://github.com/keptn/examples used for the sockshop app

### 7 - Easytravel app

Easytravel is still experimental.

The loadgen pods drive load to the staging and production angular frontends.

The loadgen to the www-staging also works.

You will need to create application detection rules, as these cannot be created by the API.

- All domains containing easytravel-angular.easytravel-production
- All domains that match easytravel-angular.easytravel-staging
- All domains that match easytravel-www.easytravel-staging

TODO: Make problem patterns dynamic.

### 8 - Next Steps

1. Verify Dynatrace config items.
1. Verify application deployments in the Keptn bridge.
1. if necessary, use Jenkins pipelines to deploy application services. 
   - Carts for example does not always deploy cleanly.
1. Use Jenkins to drive load against the KeptOrders application.  
   - I run this a few times.
1. You may need to set the Anomaly detection, for services, to have a sensitivity of "high" for failure rates.
1. Exclude the loadgen processes from monitoring in Dynatrace.
1. Check out your KIAB homepage and explore the links.
1. Explore the dashboards in Dynatrace.
1. Have some fun....

### 9 - Dynatrace SLI Service (Extra Credit)
The dynatrace-sli-service is a Keptn service that is responsible for retrieving the values of SLIs from your Dynatrace 
Tenant via the Dynatrace Metrics v2 API endpoint. For that it handles the Keptn Event sh.keptn.internal.event.get-sli 
which gets executed as part of a quality gate evaluation! 
[Dynatrace SLI Service](https://github.com/keptn-contrib/dynatrace-sli-service)

Rest easy, we have created a script to initialize the SLI service and create an OOB Dashboard example.
```bash
cd ~/keptn-in-a-box/resources/dynatrace
```
Validate the KEPTN_DOMAIN environment variable has been set.

If it has not been set, then you will need to set the KEPT_DOMAIN environment variable.

Set the KEPTN_DOMAIN 

```bash
export KEPTN_DOMAIN=<Your DOMAIN>
```

Run this script, first make it executable.
```bash
chmod +x setdbenv.sh
./setdbenv.sh
```
This will enable your Dynatrace SLO-based dashboard.

<img src="doc/images/dashboard-slo.png" width="500"/>

Now we need to trigger a quality gate evaluation.

```bash
cd ~/keptn-in-a-box/resources/demo
chmod +x triggerDashbaordSLI.sh
./triggerDashbaordSLI.sh
```
Now if you navigate to the carts service under the sockshop project in Keptn, you will see the SLI's from the configured dashboard.

<img src="doc/images/kgqslodahboard.png" width="500"/>

You can also navigate to the dashboard in Dynatrace to check out how the SLI's have been created.
Also, any subsequent builds for the sockshop app will use the Dashboard SLI's.


## Troubleshooting

:arrow_right: [Troubleshooting](#troubleshooting-and-inspecting-the-installation)

## Further reading to understand the installed modules and troubleshooting steps.

#####  The installed modules

The default installation is **installationBundleAll** which sets the control flags to true or false for the following modules:
**Note: full install for complete demo capabilities**

```bash
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  setup_proaliases=true
  enable_k8dashboard=true
  istio_install=true
  helm_install=true
  certmanager_install=true
  certmanager_enable=true
  # install keptn
  keptn_install=true
  # clone repos
  keptn_examples_clone=true
  resources_clone=true
  keptn_catalog_clone=true
  hostalias=false
  # gitea
  git_deploy=true
  git_migrate=true
  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true
  # install Dynatrace Operator
  dynatrace_install_dynakube=true
  # Dynatrace_service
  dynatrace_install_service=true
  dynatrace_install_sli_service=false
  # Traditional ActiveGate
  dynatrace_activegate_install=false
  dynatrace_configure_workloads=true
  keptndeploy_homepage=true
  # unleash
  keptndemo_unleash=true
  keptndemo_unleash_configure=true
  # sockshop application
  keptndemo_cartsonboard=true
  keptndemo_cartsload=true
  # use for order application
  keptndemo_catalogonboard=true
  # use for easytravel
  keptndemo_easytravelonboard=true
  keptndemo_easytraveloadgen=true
  # dashboards for AIOPs
  keptndashboard_load=true
  # create custom metrics
  createMetrics=true
  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true
  patch_kubernetes_dashboard=true
  keptn_bridge_disable_login=true
  # By default no WorkshopUser will be created
  create_workshop_user=false
  jmeter_install=true
  dynatrace_project=true
  post_flight=true
  patch_config_service=false
```

Dynatrace OneAgent and Dynatrace ActiveGate will be installed and configured if you provided your credentials. Otherwise they won't be installed. 

The script will install all the modules shown above and the github repository will be cloned in the home (~) directory of the sudo user that executed the script.

>The script was first created  to be run as root without an interactive shell since it is passed as userdata on creation of the elastic cloud machine via a python rest automation program.

## 💪Empower your Keptn-in-a-box 🎁 with Dynatrace by adding your credentials

- Use the Dynatrace information for the inputs to the script:

	- TENANT="mytenant.live.dynatrace.com"
	- PAASTOKEN=myDynatracePaaSToken
	- APITOKEN=myDynatraceApiToken

     > for your tenent just use the folowing:
     >  *{your-domain}/e/{your-environment-id}* 
     > for managed or 
     > {your-environment-id}.live.dynatrace.com 
     > for SaaS.
     > You can also use 
     > {your-environment-id}.sprint.dynatracelabs.com
     > or a dev tenant if inclined.

## Create Tokens

Generate an API token and a PaaS token in your Dynatrace environment.

Log in to your Dynatrace tenant and go to **Settings > Integration > Dynatrace API**. Then, create a new API token with the following permissions

Make sure you have the **Access problem and event feed, metrics, and topology** switch enabled for the API token.

TODO: API configuration for new API token interface, standby.
### Configure the API Token
<img src="doc/images/API_token.png" width="300"/>

### Create a Dynatrace PAAS token.

In your Dynatrace tenant, go to **Settings > Integration > Platform as a Service**, and create a new PaaS Token.

For more details on the Integration with Dynatrace read the following links:
- [OneAgent Operator](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/oneagent-with-helm/)
- [API Authentication](https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/basics/dynatrace-api-authentication/)
- [PaaS Token](https://www.dynatrace.com/support/help/reference/dynatrace-concepts/environment-id/#anchor_paas)
- [Kubernetes Cluster Monitoring with Dynatrace](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/connect-kubernetes-clusters-to-dynatrace/)
- [Kubernetes Events](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/events/)
- [Kubernetes Workloads](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/monitor-workloads-kubernetes/)


With the **installationModulesDefault** or **installationModulesFull** Dynatrace is automatically installed if the credentials are configured.

:arrow_right:  [Back](#arrow_right-create-tokens)

## Other installation options
### Spin your preconfigured Keptn-in-a-box machines with userdata  (manually in aws)
1. Log in to AWS
2. Click on "Launch instance"
3. Select "Ubuntu Server [18|20].04 LTS (HVM) "
4. Choose your Instance Type "t2.xlarge" or 2xlarge recommended.
5. Select "Next - configure instance details"
6. In Configure Instance details - Advanced options (below) copy the keptn-in-a-box.sh file. (as string or drop it, doesn't matter). Remember to edit your file if you want to customize your box.
7. Review it and launch your instance.

### Spin your preconfigured Keptn-in-a-box machines  with userdata (automated)
- Description to be added. Please see the [Dynatrace Rest Tenant Automation project](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation) for reference. The RTA project can spin as many instances as you want by providing a simple CSV file. It will also create and configure Dynatrace environments for each CSV entry, 😍 perfect for delivering workshops 👨‍💻. If you are interested in a workshop get in contact with us. 


## 🛠 Customizing your installation

The keptn-in-a-box project is highly customizable (obviously since it's a bashfile) below are some customizations that are the most used. All customizations can and should be done in the ** keptn-in-a-box.sh** file and not in the **functions.sh** file. This way you keep a nice delegation of tasks and functionality. 

### Change the installation Bundle
Comment out the Default and uncomment the installation type you want. For example for a Demo:

```bash
# ==================================================
#    ----- Select your installation Bundle -----   #
# ==================================================
# Uncomment for installing only Keptn 
# installationBundleKeptnOnly

# - Comment out if selecting another bundle
#installationBundleDemo

# - Comment out if only want to install only the QualityGates functionality
#installationBundleKeptnQualityGates

# - Uncomment for installing Keptn-in-a-Box for Workshops
# installationBundleWorkshop

# - Uncomment below for installing all features
installationBundleAll

# - Uncomment below for installing a PerformanceAsAService Box
#installationBundlePerformanceAsAService
```

This will install single node kubernetes cluster, keptn, k8 dashboard and expose the endpoints. It will also clone the examples, onboard the carts sample app and add a quality gate.  

### 🏁🚦Performance as a Service  (installationBundlePerformanceAsAService)
This scenario will create a Box for delivering Performance as a Service in an instant. It will install the QualityGates functionality of Keptn  (not installing the other Keptn services and/or components such as Istio). It will install Jenkins preconfigured and managed as Code with 6 example pipelines. You only need to Tag your service in Dynatrace and (if wanting to do a loadtest) provide the URL of your application do a sample Loadtest and validate it. 
If you want to learn more about Qualitygates and SRE Driven development, take a look at the following tutorial:
https://tutorials.keptn.sh/tutorials/keptn-progressive-delivery-dynatrace/

#### The sample pipelines
<img src="doc/images/qualitygates.png" width="450px" title="Keptn-in-a-Box"> 

For example triggering the first quality gate and evaluating a service will look something like this:

<img src="doc/images/pipeline-validation.png" width="450px" title="Keptn-in-a-Box"> 

> Info: The first launch of the pipeline wil fail since they need to be initialized and they need parameters to do so. it is ok, on the second run, it will ask you for your information.

1. 01-deploy-order-application - Deploy the keptnorders application
2. 01.1-easytravel-delivery - Deploy the easytravel application
3. 01.2-Sockshop Delivery - Deploy the sockshop application
4. 02-qualitygate-evaluation -  will do only the evaluation of the given service and timeframe
5. 03-simpletest-qualitygate - will do a simple multi-step test directly from Jenkins via HTTP and do the validation via keptn.
6. 04-performancetest-qualitygate - will do a Loadtest based on a simple JMeter script. 

:arrow_right:  [Back](#2---review-and-understand-the-problem-scenerios)

#### Post Flight git 
For migrating keptn projects to your self-hosted git repository afterwards just execute the following.
To make it easier, I created a script you can execute to add to the upstream git repo.
Here is the helper script. 

```bash
cd ~$KEPTN_IN_A_BOX_DIR/resources/gitea
./update-git-keptn-post-flight.sh <DOMAIN>
```
**The Domain is required**

:arrow_right:  [Back](#6---available-builds-problem-patters-and-scenerios-for-sockshop)

### Change your own Domain
By default the Script will get the public ip and give it a magic domain with nip.io like ip=1.2.3.4 will become 1-2-3-4.nip.io. This way with an NGINX Ingress Keptn and all Istio and Kubernetes services are available with subdomains via the standard HTTP ports 443 and 80.

This example could apply if I want to run a box in a VirtualMachine in my home network:
```bash
DOMAIN=192.168.0.1.nip.io
```

### 🔒 Generate valid certificates with Lets Encrypt 

By adding/commenting out the following control flags, you'll install Certmanager. A Cluster Issuer will be added and a valid certificate with let's encrypt for your public endpoints will be created. This way the exposed Endpoints/Services like the  Keptn API, Homepage, or Kubernetes API will have a valid Certificate. The Certificate renewal will happen automatically.

```bash
certmanager_install=true
certmanager_enable=true
```

If you provide your Email, the Cluster issuer will be created with the given email account. If left empty a fake Email account will be generated.
for metrics and dashboards, match your Dynatrace account email.

```bash
CERTMANAGER_EMAIL="youremail@yourdomain.com"
```

Add the modules before the `doInstallation` 

### 👨‍💻 Create a Workshop user 
You might have notice the following variables:
```bash
NEWPWD="dynatrace"
NEWUSER="dynatrace"
```
This variables in combination with the control flag `create_workshop_user=false` will create a workshop user. It will clone the `USER` home directory and add hi configuration so the `NEWUSER` can also interact with `keptn`, `docker` and `kubectl`. An SSH Password will be configured and allowed.

###  Change the Version of a component
These are the actual versions of the different Modules
```bash
# **** Installation Versions **** 
# ==================================================
#      ----- Components Versions -----             #
# ==================================================
KIAB_RELEASE="0.8.8"
ISTIO_VERSION=1.9.1
CERTMANAGER_VERSION=0.14.0
KEPTN_VERSION=0.10.0
KEPTN_DT_SERVICE_VERSION=0.18.0
KEPTN_DT_SLI_SERVICE_VERSION=0.12.1
KEPTN_EXAMPLES_REPO="https://github.com/keptn/examples.git"
KEPTN_EXAMPLES_BRANCH="0.10.0"
KEPTN_EXAMPLES_DIR="~/examples"
KEPTN_CATALOG_REPO="https://github.com/jyarb-keptn/overview.git"
KEPTN_CATALOG_BRANCH="0.8.5"
KEPTN_CATALOG_DIR="~/overview"
TEASER_IMAGE="pcjeffmac/nginxacm:0.8.1"
KEPTN_BRIDGE_IMAGE="keptn/bridge2:0.8.0"
MICROK8S_CHANNEL="1.19/stable"
KEPTN_IN_A_BOX_REPO="https://github.com/jyarb-keptn/keptn-in-a-box.git"
KEPTN_IN_A_BOX_DIR="~/keptn-in-a-box"
```
Feel free to experiment and change the versions. We will try to keep the list up to date. 
Be careful here as certain deprecations will effect the build

###  Create your custom installation
At the begining of the  `functions.sh` file the installation modules are listed. You can enable them in the `keptn-in-a-box.sh` file before calling the `doInstallation` function.

## Troubleshooting and inspecting the installation

1) Inspect the installation 

```bash
less +F /tmp/install.log
```
To view a verbose output (of every executed command) set the following control flag `verbose_mode=true` 

### Rebuild environment 

If you need to rebuild the environment, follow these steps.

```bash
cd ~/keptn-in-a-box
```

1. The following script will reset the Ubuntu instance by removing Kubernetes, the Dynatrace ActiveGate and any configuration.

```bash
./resetenv.sh
```

2. In your Dynatrace tenant Delete the kubernetes connection, under "cloud and virtualization"

Now we need to re-initialize the environment.

3. Run the following commands, then follow the process from Step 4 above.
    
```bash
cd ~
sudo bash -c './keptn-in-a-box.sh'
```

[Continue from step 4](#run-it-in-an-available-machine--manually)

### Missing request attributes 

Run the following script.

```bash
cd ~/overview/keptn-onboarding/scripts
./createRequestAttributes.sh
```

### Missing calculated service metrics

A common issue is the creation of the Calculated service metrics. If you do not have four calculated service metrics. 

run the following script with the inputs.

```bash
cd ~/overview/keptn-onboarding/scripts/
./createTestStepCalculatedMetrics.sh CONTEXTLESS keptn_project keptnorders
```

## DeepDive into the project (understanding how Microk8s, NGINX Ingress routing, Istio and Keptn work together)

This project was first presented to the Keptn Community in a Keptn Developer Meeting on the 23rd of April 2020.

#### 📹Here is the recording of the Video: Keptn in a Box - Delivering Autonomous Cloud out of the Box
<a alt="Keptn in a Box - Delivering Autonomous Cloud out of the Box" href="https://www.youtube.com/watch?v=A9ZYdih0anE" target="_blank"><img src="doc/images/Keptn-in-a-box-delivering-Autonomous-Cloud-out-of-the-box-YouTube.png" width="500px" title="Keptn-in-a-Box"/></a>


Join the [Keptn Community](https://github.com/keptn/community) for more interesting projects and keep up to date with Keptn!


#### On a high level Kubernetes architecture this is how the setup of the Microkubernetes machine is setted up:
![#](doc/images/micro-diagram-with-keptn.png)


### What we deployed

KIAB (Keptn in a Box)

| Componenet | Details |
| ---------- | ------ |
| Kubernetes | <ul><li>API</li><li>Cluster</li></ul> |
| [Keptn](https://keptn.sh/) | <ul><li>API</li><li>Bridge</li></ul> |
| Upstream Git | <ul><li>API</li><li>Repositories</li></ul> |
| CI/CD | <ul><li>Jenkins</li><li>Unleash</li></ul> |
| Order Application | <ul><li>Frontend Service</li><li>Customer Service</li><li>Catalog Service</li><li>Order Service</li></ul> |
| SockShop Application | <ul><li>Carts</li><li>Carts DB</li></ul> |
| Easytravel Application | <ul><li>Frontend</li><li>Backend</li><li>Nginx</li><li>Easytravel Mongo DB</li></ul> |


## Contributing
If you have any ideas for improvements or want to contribute that's great. Create a pull request or file an issue.

## Authors 
sergio.hinojosa@dynatrace.com
<br>
jeffery.yarbrough@dynatrace.com

