pipeline { //start pipeline
    agent {label 'builder'}
    tools {maven "Maven3"}
    environment {ARTIFACTORY_CRED = credentials('vagrant user')}
    parameters {
        string(name: 'image_name', defaultValue: 'maven_image', description: 'Docker Image')
        string(name: 'container_name', defaultValue: 'maven_app', description: 'Container Name')
    }
stages { //start stages
            stage ('Get code from GIT') { 
                steps { 
                    git 'https://github.com/sabinstoica/mvn_complex_2.git'
                       } 
            }
            stage('Build package') { 
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
                        sh "mvn deploy -f app/ -Dusername=${ARTIFACTORY_CRED_USR} -Dpassword=${ARTIFACTORY_CRED_PSW} -DbuildNumber=${env.BUILD_NUMBER}"
                      }
                } //stop stage Deploy
            stage('Build Image') {
            steps {
                // Build Image
                sh "docker build -t docker.artifactory.local/$image:${env.BUILD_NUMBER} ."
                //sh "docker build -t docker.artifactory.local/$image:${env.BUILD_NUMBER} . --label \"type=maven_image\""
            }
        } //stop stage Build Image
            stage('Deploy Image to Artifactory'){
            steps {
                        sh "echo \"${ARTIFACTORY_CRED_PSW}\" | docker login -u \"${ARTIFACTORY_CRED_USR}\" docker.artifactory.local --password-stdin"
                        sh "docker push docker.artifactory.local/$image:${env.BUILD_NUMBER}"
                  }
            }   
            stage('Pull/Deploy App'){
            steps {
                // Pull docker image from docker registry
                        sh "echo \"${ARTIFACTORY_CRED_PSW}\" | docker login -u \"${ARTIFACTORY_CRED_USR}\" docker.artifactory.local --password-stdin"
                        sh "docker pull docker.artifactory.local/$image:${params.tag}"
                // Docker run
                        sh "docker run -p 8089:8080 -d --name $container docker.artifactory.local/$image:${params.tag}"
                    }
            } // stop 'Pull/Deploy App' stage
         } // stop stages
} // stop pipeline
