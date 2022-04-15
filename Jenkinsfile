pipeline { //start pipeline
    agent {label 'builder'}
    tools {maven "Maven3"}
    environment {ARTIFACTORY_CRED = credentials('vagrant user')}
stages { //start stages
            stage ('Get code from GIT') { 
                steps { 
                    git 'https://github.com/sabinstoica/mvn_complex_2.git'
                       } 
            }
            stage('build') { 
                 steps { 
                      sh "mvn -f app/ clean package"
                       } // stop steps build 
                 }
            stage('SonarQube analysis') { 
                steps { 
                        withSonarQubeEnv('sonar2')  {
                        sh "mvn -f app/ sonar:sonar" }
                                            }
                }
            stage("Quality gate") {
                steps {
                        waitForQualityGate abortPipeline: true
            } // stop steps Quality gate 
                                 } //stop stage Quality gate
            stage ("Deploy package to artifactory") {
                steps {
                        sh "mvn deploy -f app/ -Dusername=${ARTIFACTORY_CRED_USR} -Dpassword=${ARTIFACTORY_CRED_PSW} -D${env.BUILD_NUMBER}"
                      }
                } //stop stage Deploy
         } // stop stages
} // stop pipeline
