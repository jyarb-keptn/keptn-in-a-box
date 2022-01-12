@Library('keptn-library@master')_
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()

def TEST_START = 'UNKNOWN'
def TEST_END = 'UNKNOWN'

def tags = ['easytravel-www', 'easytravel-frontend', 'easytravel-backend', 'easytravel-mongodb']

def source = 'Jenkins'

def key = 'app'

pipeline {

agent any

    parameters {
        string (name: 'project', defaultValue: 'keptn_project: keptnorders')
        string (name: 'buildenv', defaultValue: 'staging')
        string (name: 'buildVersion', defaultValue: '1.0.0')
	    string (name: 'LoadTestTime', defaultValue: '3')
	    string (name: 'ThinkTime', defaultValue: '1000')		
        string (name: 'DeploymentURI', defaultValue: "${env.ORDER_STAGING}")
        string (name: 'URLPaths', defaultValue: '/:homepage;/order:order;/customer/list.html:customer;/catalog/list.html:catalog;/order/form.html:orderForm')
        string (name: 'remediationAction', defaultValue: 'https://remediation-playbook')
        string (name: 'qgProject', defaultValue: 'keptnorders') 
        string (name: 'Stage', defaultValue: 'staging') 
        string (name: 'Service', defaultValue: 'eval')
	    string (name: 'TimeZone', defaultValue: 'UTC')
	    string (name: 'Monitoring', defaultValue: 'dynatrace')
        string (name: 'SLI', defaultValue: 'perftest')
        string (name: 'StartTime', defaultValue: '200')
        string (name: 'EndTime', defaultValue: '30')
        string (name: 'WaitForResult', defaultValue: '3')        
	}

stages{	
   stage('App-Deployment') {
     steps{
       echo "Place your deployment steps here..."
     }
   }
   
   stage('App-warmup') {
       steps {
        echo "This is really just a very simple 'load simulated'. Dont try this at home :-)" 
        echo "For real testing - please use A REAL load testing tool in your pipeline such us JMeter, Neoload, Gatling ... - but - this is good for this demo"     
	       
        script {
        	TEST_START = sh(script: 'echo "$(TZ=":US/Eastern" date -u +%s)000"', returnStdout: true).trim()
        }	    

        // now we run the test
        script {
	    loadTestTime = '1'
            thinkTime = params.ThinkTime
            url = params.DeploymentURI
            urlPaths = params.URLPaths
            urlPathValues = urlPaths.tokenize(';')	
				
            runTestUntil = java.time.LocalDateTime.now().plusMinutes(loadTestTime.toInteger())
            echo "wait for containers to start"
            sleep(time:5,unit:"SECONDS")
             
            echo "Lets run a test until: " + runTestUntil.toString()

            while (runTestUntil.compareTo(java.time.LocalDateTime.now()) >= 1) {
                // we loop through every URL that has been passed
                for (i=0;i<urlPathValues.size();i++) {
                    urlPath = urlPathValues[i].tokenize(':')[0]
                    testStepName = urlPathValues[i].tokenize(':')[1]

                    // Sends the request to the URL + Path and also send some x-dynatrace-test HTTP Headers: 
                    // TSN=Test Step Name, LSN=Load Script Name, LTN=Load Test Name
                    // More info: https://www.dynatrace.com/support/help/setup-and-configuration/integrations/third-party-integrations/test-automation-frameworks/dynatrace-and-load-testing-tools-integration/
                    def response = httpRequest customHeaders: [[maskValue: true, name: 'x-dynatrace-test', value: "TSN=${testStepName};LSN=SimpleTest;LTN=simpletest_${BUILD_NUMBER};"]], 
                        httpMode: 'GET', 
                        responseHandle: 'STRING', 
                        url: "${url}${urlPath}", 
                        validResponseCodes: "100:500", 
                        ignoreSslErrors: true,
                        quiet: true
                }
                sleep(time:ThinkTime,unit:"MILLISECONDS")
            }
	}		

	script {
        	TEST_END = sh(script: 'echo "$(TZ=":US/Eastern" date -u +%s)000"', returnStdout: true).trim()
        } 

       }       
    }   
   
   
   stage('Event-Post-Host') {
   		steps {
        	script {  
		    meType = 'HOST'
		    context = 'ENVIRONMENT'
		    hostkey = 'project'
		    value = 'kiab'
		    	
		
        	jsonPayload = """{"eventType": "CUSTOM_DEPLOYMENT",
  				"attachRules": {
    				"tagRule" : [ 
				 {
        			   "meTypes" : [ 
				        "${meType}"
				      ],
				      "tags" : [
				         {
				          "context": "${context}",
					  "key" : "${hostkey}",
                      "value" : "${value}"
					 }
					 ]
				     }
				     ] 
    			},
  					"deploymentName":"${JOB_NAME} - ${BUILD_NUMBER} ${params.buildenv} (host)",
  					"deploymentVersion":"${params.buildVersion}-${BUILD_NUMBER}",
  					"deploymentProject":"${params.project}",
  					"remediationAction":"${params.remediationAction}",
  					"ciBackLink":"${BUILD_URL}",
  					"source":"${source}",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}",
    					"Job URL": "${JOB_URL}",
    					"Commits": "${GIT_COMMIT}",
    					"Git URL": "${GIT_URL}"
  						}
					}"""
				}	
		        //echo "payload: ${jsonPayload}"			
			httpRequest (acceptType: 'APPLICATION_JSON', 
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
		        quiet: true)        			
    } } 

    stage('Event-Post-Service-keptnOrders-orders') {
        steps {
            script {
		     meType = 'SERVICE'
		     context = 'CONTEXTLESS' 
		     key = 'keptn_service'   
		     value = 'order 
				   
        	jsonPayload = """{"eventType": "CUSTOM_DEPLOYMENT",
  					"attachRules": {
    				"tagRule" : [ 
				      {
        			   "meTypes" : [ 
				        "${meType}"
				        ],
				      "tags" : [
				         {
				          "context": "${context}",
					      "key" : "${key}",
                          "value" : "${value}"
					      }
					   ]
				     }
				     ] 
    				},
  					"deploymentName":"${JOB_NAME} - ${BUILD_NUMBER} ${params.buildenv} (${key})",
  					"deploymentVersion":"${params.buildVersion}-${BUILD_NUMBER}",
  					"deploymentProject":"${params.project}",
  					"remediationAction":"${params.remediationAction}",
  					"ciBackLink":"${BUILD_URL}",
  					"source":"${source}",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}",
    					"Job URL": "${JOB_URL}",
    					"Commits": "${GIT_COMMIT}",
    					"Git URL": "${GIT_URL}"
  						}
					}"""
				}		
			httpRequest (acceptType: 'APPLICATION_JSON',  
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
			quiet: false)		
	} }
     
    stage('Event-Post-version-frontend') {
        steps {
                        
            script {
		     eventType = 'CUSTOM_DEPLOYMENT'    
		     meType = 'PROCESS_GROUP_INSTANCE'
		     context = 'KUBERNETES'
		     key = 'app'    
		     value = 'frontend'    

		     jsonPayload = """{"eventType": "${eventType}",
  				"attachRules": {
    				"tagRule" : [ 
				    {
        			   "meTypes" : [ 
				        "${meType}"
				      ],
				      "tags" : [
				         {
				          "context": "${context}",
					      "key" : "${key}",
                          "value" : "${value}"
					     },
				         {
				          "context": "CONTEXTLESS",
					      "key" : "keptn_stage",
                          "value" : "staging"
					     }					     
					   ]
				     }
				     ] 
    				},
  					"deploymentName":"${JOB_NAME} - ${BUILD_NUMBER} ${params.buildenv} (${value})",
  					"deploymentVersion":"${params.buildVersion}-${BUILD_NUMBER}",
  					"deploymentProject":"${params.project}",
  					"remediationAction":"${params.remediationAction}",
  					"ciBackLink":"${BUILD_URL}",
  					"source":"${source}",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}",
    					"Job URL": "${JOB_URL}",
    					"Commits": "${GIT_COMMIT}",
    					"Git URL": "${GIT_URL}"
  						}
					}"""
			}
			//echo "payload: ${jsonPayload}"
			httpRequest (acceptType: 'APPLICATION_JSON',  
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
			quiet: false)

	} }  		  

    stage('Event-Post-version-order') {
        steps {
            script {
		    eventType = 'CUSTOM_DEPLOYMENT'    
		    meType = 'PROCESS_GROUP_INSTANCE'
		    context = 'KUBERNETES'
		    key = 'app'    
		    value = 'order' 
		    
        	jsonPayload = """{"eventType": "${eventType}",
  				"attachRules": {
    				"tagRule" : [ 
				    {
        			   "meTypes" : [ 
				        "${meType}"
				      ],
				      "tags" : [
				         {
				          "context": "${context}",
					      "key" : "${key}",
                          "value" : "${value}"
					     },
				         {
				          "context": "CONTEXTLESS",
					      "key" : "keptn_stage",
                          "value" : "staging"
					     }					     
					   ]
				     }
				     ]
    				},
  					"deploymentName":"${JOB_NAME} - ${BUILD_NUMBER} ${params.buildenv} (${value})",
  					"deploymentVersion":"${params.buildVersion}-${BUILD_NUMBER}",
  					"deploymentProject":"${params.project}",
  					"remediationAction":"${params.remediationAction}",
  					"ciBackLink":"${BUILD_URL}",
  					"source":"${source}",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}",
    					"Job URL": "${JOB_URL}",
    					"Commits": "${GIT_COMMIT}",
    					"Git URL": "${GIT_URL}"
  						}
					}"""
			}
			httpRequest (acceptType: 'APPLICATION_JSON', 
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
			quiet: true)
	} }		
	
    stage('Event-Post-version-customer') {
        steps {
            script {
		    eventType = 'CUSTOM_DEPLOYMENT'    
		    meType = 'PROCESS_GROUP_INSTANCE'
		    context = 'KUBERNETES'
		    key = 'app'    
		    value = 'customer' 
		    
        	jsonPayload = """{"eventType": "${eventType}",
  				"attachRules": {
    				"tagRule" : [ 
				    {
        			   "meTypes" : [ 
				        "${meType}"
				      ],
				      "tags" : [
				         {
				          "context": "${context}",
					      "key" : "${key}",
                          "value" : "${value}"
					     },
				         {
				          "context": "CONTEXTLESS",
					      "key" : "keptn_stage",
                          "value" : "staging"
					     }					     
					   ]
				     }
				     ]
    				},
  					"deploymentName":"${JOB_NAME} - ${BUILD_NUMBER} ${params.buildenv} (${value})",
  					"deploymentVersion":"${params.buildVersion}-${BUILD_NUMBER}",
  					"deploymentProject":"${params.project}",
  					"remediationAction":"${params.remediationAction}",
  					"ciBackLink":"${BUILD_URL}",
  					"source":"${source}",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}",
    					"Job URL": "${JOB_URL}",
    					"Commits": "${GIT_COMMIT}",
    					"Git URL": "${GIT_URL}"
  						}
					}"""
			}
			httpRequest (acceptType: 'APPLICATION_JSON', 
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
			quiet: true)
	} } 		  

    stage('Event-Post-version-catalog') {
        steps {
            script {
		    eventType = 'CUSTOM_DEPLOYMENT'    
		    meType = 'PROCESS_GROUP_INSTANCE'
		    context = 'KUBERNETES'
		    key = 'app'    
		    value = 'catalog' 
		    
        	jsonPayload = """{"eventType": "${eventType}",
  				"attachRules": {
    				"tagRule" : [ 
				    {
        			   "meTypes" : [ 
				        "${meType}"
				      ],
				      "tags" : [
				         {
				          "context": "${context}",
					      "key" : "${key}",
                          "value" : "${value}"
					     },
				         {
				          "context": "CONTEXTLESS",
					      "key" : "keptn_stage",
                          "value" : "staging"
					     }					     
					   ]
				     }
				     ]
    				},
  					"deploymentName":"${JOB_NAME} - ${BUILD_NUMBER} ${params.buildenv} (${value})",
  					"deploymentVersion":"${params.buildVersion}-${BUILD_NUMBER}",
  					"deploymentProject":"${params.project}",
  					"remediationAction":"${params.remediationAction}",
  					"ciBackLink":"${BUILD_URL}",
  					"source":"${source}",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}",
    					"Job URL": "${JOB_URL}",
    					"Commits": "${GIT_COMMIT}",
    					"Git URL": "${GIT_URL}"
  						}
					}"""
			}
			httpRequest (acceptType: 'APPLICATION_JSON', 
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
			quiet: true)
	} } 		 	

    stage('Run simple load test') {
       steps {
        echo "This is really just a very simple 'load simulated'. Dont try this at home :-)" 
        echo "For real testing - please use A REAL load testing tool in your pipeline such us JMeter, Neoload, Gatling ... - but - this is good for this demo"     
	       
        script {
        	TEST_START = sh(script: 'echo "$(TZ=":US/Eastern" date -u +%s)000"', returnStdout: true).trim()
        }	    

        // now we run the test
        script {
	    loadTestTime = params.LoadTestTime
            thinkTime = params.ThinkTime
            url = params.DeploymentURI
            urlPaths = params.URLPaths
            urlPathValues = urlPaths.tokenize(';')	
				
            runTestUntil = java.time.LocalDateTime.now().plusMinutes(loadTestTime.toInteger())
            echo "wait for containers to start"
            sleep(time:5,unit:"SECONDS")
             
            echo "Lets run a test until: " + runTestUntil.toString()

            while (runTestUntil.compareTo(java.time.LocalDateTime.now()) >= 1) {
                // we loop through every URL that has been passed
                for (i=0;i<urlPathValues.size();i++) {
                    urlPath = urlPathValues[i].tokenize(':')[0]
                    testStepName = urlPathValues[i].tokenize(':')[1]

                    // Sends the request to the URL + Path and also send some x-dynatrace-test HTTP Headers: 
                    // TSN=Test Step Name, LSN=Load Script Name, LTN=Load Test Name
                    // More info: https://www.dynatrace.com/support/help/setup-and-configuration/integrations/third-party-integrations/test-automation-frameworks/dynatrace-and-load-testing-tools-integration/
                    def response = httpRequest customHeaders: [[maskValue: true, name: 'x-dynatrace-test', value: "TSN=${testStepName};LSN=SimpleTest;LTN=simpletest_${BUILD_NUMBER};"]], 
                        httpMode: 'GET', 
                        responseHandle: 'STRING', 
                        url: "${url}${urlPath}", 
                        validResponseCodes: "100:500", 
                        ignoreSslErrors: true,
                        quiet: true
                }
                sleep(time:ThinkTime,unit:"MILLISECONDS")
            }
	}		

	script {
        	TEST_END = sh(script: 'echo "$(TZ=":US/Eastern" date -u +%s)000"', returnStdout: true).trim()
        } 

       }       
    }	
	
   stage('Annotation-Post') {
       steps {
        echo "StartTime: ${TEST_START}"	
        echo "EndTime: ${TEST_END}"	       
       		script { 
		eventType = 'CUSTOM_ANNOTATION'
		meType = 'SERVICE'	
		context = 'KUBERNETES'
		key = 'app'	
		value = 'frontend'	
			
        	jsonPayload = """{"eventType": "${eventType}",
  				"attachRules": {
    				"tagRule" : [ 
				 {
        			  "meTypes" : [
				      "${meType}"
				      ],
        			      "tags" : [ 
					 {
					   "context": "${context}",
					   "key" : "${key}",
                                           "value" : "${value}"
					 }
				        ]
    				     }
				     ]	
  				   },
  					"source":"${source}",
  					"annotationType": "LoadTest",
  		                        "annotationDescription": "http load test",
  					"customProperties":{
    					"Jenkins Build Number": "${BUILD_ID}",
    					"Environment": "${params.buildenv}"
  						},
  						"start": ${TEST_START},
  						"end": ${TEST_END} 
					}"""
        	}
			httpRequest (acceptType: 'APPLICATION_JSON', 
			contentType: 'APPLICATION_JSON', 
			customHeaders: [[maskValue: true, name: 'Authorization', 
			value: "Api-Token ${DT_API_TOKEN}"]], 
			httpMode: 'POST', 
			ignoreSslErrors: true, 
			requestBody: jsonPayload, 
			responseHandle: 'NONE', 
			url: "https://${DT_TENANT}/api/v1/events/",
			validResponseCodes: '200',
			quiet: true)
	} }  
		
    stage('Initialize Keptn') {
      steps{
        script { 
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.9/resources/jenkins/pipelines/keptn/dynatrace/dynatrace.conf.yaml", 'keptn/dynatrace/dynatrace.conf.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.9/resources/jenkins/pipelines/keptn/slo_${params.SLI}.yaml", 'keptn/slo.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/keptn-in-a-box/0.8.9/resources/jenkins/pipelines/keptn/dynatrace/sli_${params.SLI}.yaml", 'keptn/sli.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/jyarb-keptn/overview/0.8.5/easytravel-onboarding/shipyard.yaml", 'keptn/shipyard.yaml')
        archiveArtifacts artifacts:'keptn/**/*.*'

        // Initialize the Keptn Project - ensures the Keptn Project is created with the passed shipyard
        keptn.keptnInit project:"${params.qgProject}", service:"${params.Service}", stage:"${params.Stage}", monitoring:"${monitoring}", shipyard:'keptn/shipyard.yaml'

        // Upload all the files
        keptn.keptnAddResources('keptn/shipyard.yaml','shipyard.yaml')
        keptn.keptnAddResources('keptn/dynatrace/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
        keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
        }
        }
    }

    stage('Trigger Quality Gate') {
      steps{
        echo "Quality Gates ONLY: Just triggering an SLI/SLO-based evaluation for the passed timeframe"
        script {  
        // Trigger an evaluation
        def keptnContext = keptn.sendStartEvaluationEvent starttime:"${params.StartTime}", endtime:"${params.EndTime}", timezone:"${params.TimeZone}" 
        String keptn_bridge = env.KEPTN_BRIDGE
        echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
      }
      }  
    }

    stage('Wait for Result') {
      steps{
        script{ 
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
    }   
 }    
}
