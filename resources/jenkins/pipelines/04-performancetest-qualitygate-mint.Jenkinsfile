@Library('keptn-library@5.1')_
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()

node {

    environment {
         String order_url = env.ORDER_PROD
    } 

    properties([
        parameters([
         string(defaultValue: 'performance', description: 'Name of your Keptn Project for Performance as a Self-Service', name: 'Project', trim: false), 
         string(defaultValue: 'performancestage', description: 'Stage in your Keptn project used for Performance Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'peval', description: 'Servicename used to keep SLIs, SLOs, test files ...', name: 'Service', trim: false),
         choice(choices: ['dynatrace', 'prometheus',''], description: 'Select which monitoring tool should be configured as SLI provider', name: 'Monitoring', trim: false),
         choice(choices: ['performance', 'performance_10', 'performance_50', 'performance_100', 'performance_long'], description: 'Test Strategy aka Workload, e.g: performance, performance_10, performance_50, performance_100, performance_long', name: 'TestStrategy', trim: false),
         choice(choices: ['perftest','basic'], description: 'Decide which set of SLIs you want to evaluate. The sample comes with: basic and perftest', name: 'SLI'),
         string(defaultValue: "${env.ORDER_PROD}", description: 'URI of the application you want to run a test against, remove the trailing slash', name: 'DeploymentURI', trim: false),
         string(defaultValue: '60', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ])
    ])

    stage('Initialize Keptn') {
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/overview/0.8.8/keptn-onboarding/shipyard-performance.yaml', 'keptn/shipyard.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.2/resources/jenkins/pipelines/keptnorders/dynatrace/dynatrace.conf.yaml", 'dynatrace/dynatrace.conf.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.2/resources/jenkins/pipelines/keptnorders/slo_${params.SLI}.yaml", 'keptnorders/slo.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.2/resources/jenkins/pipelines/keptnorders/dynatrace/sli_${params.SLI}.yaml", 'keptnorders/sli.yaml')
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.2/resources/jenkins/pipelines/keptnorders/jmeter/load.jmx', 'keptnorders/jmeter/load.jmx')
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.2/resources/jenkins/pipelines/keptnorders/jmeter/basiccheck.jmx', 'keptnorders/jmeter/basiccheck.jmx')
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.2/resources/jenkins/pipelines/keptnorders/jmeter/jmeter.conf.yaml', 'keptnorders/jmeter/jmeter.conf.yaml')
        archiveArtifacts artifacts:'keptnorders/**/*.*'

        // Initialize the Keptn Project
        keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", shipyard:'keptn/shipyard.yaml'

        // Upload all the files
        keptn.keptnAddResources('keptn/shipyard.yaml','shipyard.yaml')
        keptn.keptnAddResources('dynatrace/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        keptn.keptnAddResources('keptnorders/sli.yaml','dynatrace/sli.yaml')
        keptn.keptnAddResources('keptnorders/slo.yaml','slo.yaml')
        keptn.keptnAddResources('keptnorders/jmeter/load.jmx','jmeter/load.jmx')
        keptn.keptnAddResources('keptnorders/jmeter/basiccheck.jmx','jmeter/basiccheck.jmx')
        keptn.keptnAddResources('keptnorders/jmeter/jmeter.conf.yaml','jmeter/jmeter.conf.yaml')

        // Configure monitoring for your keptn project (using dynatrace or prometheus)
        keptn.keptnConfigureMonitoring monitoring:"${monitoring}"
                
    }
    stage('Trigger Performance Test') {
        echo "Performance as a Self-Service: Triggering Keptn to execute Tests against ${params.DeploymentURI}"

        // send deployment finished to trigger tests
        def keptnContext = keptn.sendConfigurationTriggeredEvent testStrategy:"${params.TestStrategy}", deploymentURI:"${params.DeploymentURI}"
        String keptn_bridge = env.KEPTN_BRIDGE
        echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
    }
    stage('Wait for Result') {
        waitTime = 0
        if(params.WaitForResult?.isInteger()) {
            waitTime = params.WaitForResult.toInteger()
        }

        if(waitTime > 0) {
            echo "Waiting until Keptn is done and returns the results"
            def result = keptn.waitForEvaluationDoneEvent setBuildResult:true, waitTime:waitTime
            echo "${result}"
        } else {
            echo "Not waiting for results. Please check the Keptns bridge for the details!"
        }

        // Generating the Report so you can access the results directly in Keptns Bridge
        publishHTML(
            target: [
                allowMissing         : false,
                alwaysLinkToLastBuild: false,
                keepAll              : true,
                reportDir            : ".",
                reportFiles          : 'keptn.html',
                reportName           : "Keptn Result in Bridge"
            ]
        )
    }
}
