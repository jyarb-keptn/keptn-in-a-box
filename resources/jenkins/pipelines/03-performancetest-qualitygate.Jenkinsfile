@Library('keptn-library@master')_
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()

node {

    environment {
         String order_url = env.ORDER_STAGING
    }

    properties([
        parameters([
         string(defaultValue: 'performance', description: 'Name of your Keptn Project for Performance as a Self-Service', name: 'Project', trim: false), 
         string(defaultValue: 'performancestage', description: 'Stage in your Keptn project used for Performance Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'eval', description: 'Servicename used to keep SLIs, SLOs, test files ...', name: 'Service', trim: false),
         choice(choices: ['dynatrace', 'prometheus',''], description: 'Select which monitoring tool should be configured as SLI provider', name: 'Monitoring', trim: false),
         choice(choices: ['performance', 'performance_10', 'performance_50', 'performance_100', 'performance_long'], description: 'Test Strategy aka Workload, e.g: performance, performance_10, performance_50, performance_100, performance_long', name: 'TestStrategy', trim: false),
         choice(choices: ['perftest','basic'], description: 'Decide which set of SLIs you want to evaluate. The sample comes with: basic and perftest', name: 'SLI'),
         string(defaultValue: "${env.ORDER_STAGING}", description: 'URI of the application you want to run a test against, remove the trailing slash', name: 'DeploymentURI', trim: false),
         string(defaultValue: '60', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ]),
        buildDiscarder(logRotator(daysToKeepStr: '', numToKeepStr: '10')),
        pipelineTriggers([
          parameterizedCron('''
            ##H/45 * * * * %Monitoring=dynatrace;TestStrategy=performance;SLI=perftest
        ''')
      ])                  
    ])

    stage('Initialize Keptn') {
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/overview/0.8.7/keptn-onboarding/shipyard-performance.yaml', 'keptn/shipyard.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/dynatrace/dynatrace.conf.yaml", 'keptn/dynatrace/dynatrace.conf.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/slo_${params.SLI}.yaml", 'keptn/slo.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/dynatrace/sli_${params.SLI}.yaml", 'keptn/sli.yaml')
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/jmeter/load.jmx', 'keptn/jmeter/load.jmx')
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/jmeter/basiccheck.jmx', 'keptn/jmeter/basiccheck.jmx')
        keptn.downloadFile('https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/jmeter/jmeter.conf.yaml', 'keptn/jmeter/jmeter.conf.yaml')
        archiveArtifacts artifacts:'keptn/**/*.*'

        // Initialize the Keptn Project
       keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", monitoring:"${monitoring}", shipyard:'keptn/shipyard.yaml'
        //keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", shipyard:'keptn/shipyard.yaml'

        // Upload all the files
        keptn.keptnAddResources('keptn/shipyard.yaml','shipyard.yaml')
        keptn.keptnAddResources('keptn/dynatrace/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
        keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
        keptn.keptnAddResources('keptn/jmeter/load.jmx','jmeter/load.jmx')
        keptn.keptnAddResources('keptn/jmeter/basiccheck.jmx','jmeter/basiccheck.jmx')
        keptn.keptnAddResources('keptn/jmeter/jmeter.conf.yaml','jmeter/jmeter.conf.yaml')
        // Configure monitoring for your keptn project (using dynatrace or prometheus)
        //keptn.keptnConfigureMonitoring monitoring:"${monitoring}"
    }
    stage('Trigger Performance Test') {
        echo "Performance as a Self-Service: Triggering Keptn to execute Tests against ${params.DeploymentURI}"

        // send deployment finished to trigger tests
        def keptnContext = keptn.sendConfigurationTriggeredEvent deploymentURI:"${params.DeploymentURI}", testStrategy:"${params.TestStrategy}"
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
