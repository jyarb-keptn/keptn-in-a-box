@Library('keptn-library@6.0.0-next.1')_
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()

node {
    properties([
        parameters([
         string(defaultValue: 'qualitygate', description: 'Name of your Project for Quality Gate Feedback ', name: 'Project', trim: false), 
         string(defaultValue: 'quality-gate', description: 'Stage used for for Quality Gate Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'evalservice', description: 'Name of the Tag for identifyting the service to validate the SLIs and SLOs', name: 'Service', trim: false),
         choice(choices: ['dynatrace', 'prometheus',''], description: 'Select which monitoring tool should be configured as SLI provider', name: 'Monitoring', trim: false),
         choice(choices: ['basic', 'perftest'], description: 'Decide which set of SLIs you want to evaluate. The sample comes with: basic and perftest', name: 'SLI'),
         string(defaultValue: 'UTC', description: 'TimeZone', name: 'TimeZone', trim: false),
         string(defaultValue: '660', description: 'Start timestamp or number of seconds from Now()', name: 'StartTime', trim: false),
         string(defaultValue: '60', description: 'End timestamp or number of seconds from Now(). If empty defaults to Now()', name: 'EndTime', trim: false),
         string(defaultValue: '3', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ]),
        buildDiscarder(logRotator(daysToKeepStr: '', numToKeepStr: '10')),
        pipelineTriggers([
          parameterizedCron('''
            H/30 * * * * %Monitoring=dynatrace;SLI=perftest
        ''')
      ])        
    ])

    stage('Initialize Keptn') {
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/dynatrace/dynatrace.conf.yaml", 'keptn/dynatrace/dynatrace.conf.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/slo_${params.SLI}.yaml", 'keptn/slo.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.12.1/resources/jenkins/pipelines/keptn/dynatrace/sli_${params.SLI}.yaml", 'keptn/sli.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/overview/0.8.7/keptn-onboarding/shipyard-quality-gates.yaml", 'keptn/shipyard.yaml')
        archiveArtifacts artifacts:'keptn/**/*.*'

        // Initialize the Keptn Project - ensures the Keptn Project is created with the passed shipyard
        //keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", monitoring:"${monitoring}", shipyard:'keptn/shipyard.yaml'
        keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", shipyard:'keptn/shipyard.yaml'

        // Upload all the files
        keptn.keptnAddResources('keptn/shipyard.yaml','shipyard.yaml')
        keptn.keptnAddResources('keptn/dynatrace/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
        keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
        // Configure monitoring for your keptn project (using dynatrace or prometheus)
        keptn.keptnConfigureMonitoring monitoring:"${monitoring}" 
        //keptn.keptnConfigureMonitoring monitoring:"dynatrace"      
    }
    stage('Trigger Quality Gate') {
        echo "Quality Gates ONLY: Just triggering an SLI/SLO-based evaluation for the passed timeframe"

        def labels=[:]
        labels.put('TriggeredBy', 'jenkins')
        labels.put('version', "${env.BUILD_NUMBER}")
        labels.put('evaltime', "${params.StartTime}")

        // Trigger an evaluation
        def keptnContext = keptn.sendStartEvaluationEvent starttime:"${params.StartTime}", endtime:"${params.EndTime}", labels: labels
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
