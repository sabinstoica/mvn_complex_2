pipeline { //start pipeline
    agent {label 'builder'}
    tools {maven "Maven3"}
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
         } // stop stages
} // stop pipeline
