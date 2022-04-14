pipeline { //start pipeline
    agent {label 'builder'}
    tools {maven "Maven3"}
stages { //start stages
            stage ('Get code from GIT') { // start stage 'Get code from GIT'
                steps { //start step 'Get the repo from GitHub'
                    git 'https://github.com/sabinstoica/mvn_complex_2.git'
                       } // stop step 'Get the repo from GitHub'
            } // stop stage 'stage 'Get code from GIT'
            stage('build') { //start stage 'build the package'
                 steps {
                     
                      sh "mvn -f app/ clean package"
                       }
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
            }
                                 }
         } // stop stages
} // stop pipeline
