@Library('keptn-library@6.0.0-next.1')_
import sh.keptn.Keptn
import java.time.temporal.ChronoUnit
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.*;

def keptn = new sh.keptn.Keptn()

def getNow() {
  //return java.time.LocalDateTime.now() ;
  //return java.time.Instant.now().truncatedTo( ChronoUnit.MILLIS ) ;
  LocalDateTime localDateTime = LocalDateTime.now();
  ZonedDateTime zdt = ZonedDateTime.of(localDateTime, ZoneId.systemDefault()); 
  long date = zdt.toInstant().toEpochMilli();
  return date
}

def getNowID() {
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("mmddHHMM");
  ZonedDateTime zdt = ZonedDateTime.now();
  String formattedZdt = zdt.format(formatter);
  return formattedZdt
}

node {
    properties([
        parameters([
         string(defaultValue: 'sockshop', description: 'Name of your Project for Quality Gate Feedback ', name: 'Project', trim: false), 
         string(defaultValue: 'staging', description: 'Stage used for for Quality Gate Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'carts', description: 'Name of the Tag for identifyting the service to validate the SLIs and SLOs', name: 'Service', trim: false),
         choice(name: 'Release', choices: ["0.12.1", "0.12.2", "0.12.3"], description: 'Carts Service with Tag [:0.12.1,:0.12.2,:0.12.3]')
         choice(choices: ['dynatrace', 'prometheus',''], description: 'Select which monitoring tool should be configured as SLI provider', name: 'Monitoring', trim: false),
         string(defaultValue: '660', description: 'Start timestamp or number of seconds from Now()', name: 'StartTime', trim: false),
         string(defaultValue: 'UTC', description: 'TimeZone', name: 'TimeZone', trim: false),
         string(defaultValue: '60', description: 'End timestamp or number of seconds from Now(). If empty defaults to Now()', name: 'EndTime', trim: false),
         string(defaultValue: '3', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ]),
        buildDiscarder(logRotator(daysToKeepStr: '', numToKeepStr: '10')),
        pipelineTriggers([
          parameterizedCron('''
            H/30 * * * * %Monitoring=dynatrace
        ''')
      ])         
    ])

    stage('Trigger Quality Gate') {
        echo "Quality Gates ONLY: Just triggering an SLI/SLO-based evaluation for the passed timeframe"
        
        // Initialize the Keptn Project - ensures the Keptn Project is created with the passed shipyard
        keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}"
        // Trigger an evaluation
        def scriptStartTime = getNow().toString()
        def buildid = getNowID().toString()

        def labels=[:]
        labels.put('TriggeredBy', 'jenkins')
        labels.put('version', "${params.Release}")
        labels.put('buildId', "${buildid}")
        labels.put('evaltime', "${scriptStartTime}")

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
