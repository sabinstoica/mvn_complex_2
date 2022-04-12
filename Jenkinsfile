pipeline {
    agent {
            label "lin_node"
        }
    environment {
        DOCKER_HUB_CRED = credentials('docker_cred')
        ARTIFACTORY_CRED = credentials('Artifactory_admin')
    }
    parameters {
        string(name: 'image_name', defaultValue: 'maven_image', description: 'Name of the image')
        string(name: 'container_name', defaultValue: 'my_maven_app', description: 'Name of the container')
        string(name: 'sonar_token', defaultValue: 'aca9fee4aae893fa63b46476fb1938ddaac62ed9', description: 'The token from Sonarqube')
        string(name: 'sonar_srv', defaultValue: 'http://172.30.68.55:9000', description: 'The Sonarqube server')

    }

    stages {
        stage('Fetch Git') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/Savaonu/maven_app'
            }
        }
        
        stage('Maven build') {
            agent {
                label "slave_maven_build"
            }
            steps {
                script {
        
                    //sh "mvn deploy -f artifactory-maven-plugin-example/ -s artifactory-maven-plugin-example/settings.xml"
                    def mvnHome = tool 'Maven 3.6.3'
                    //sh "'${mvnHome}/bin/mvn' -f app/ package deploy -f app/ -Dusername=admin -Dpassword=Password.123 -D${env.BUILD_NUMBER}"
                     // sh "mvn -f app/ package deploy:deploy-file -DpomFile=app/pom.xml -Dfile=app/art-build-deploy.sh -Durl=http://172.30.69.154:8081/artifactory/maven_repo/"
                }
            }
        }
        
        
        stage('Build Image') {
            agent {
                label "slave_maven_build"
            }
            steps {
                // Build Image
                sh "docker build -t ${params.image_name} ."
               //sh "mvn -f app/ sonar:sonar -Dsonar.host.url=${params.sonar_srv} -Dsonar.login=${params.sonar_token}"

                // Create container
               // sh "docker run -p 8089:8080 -d --name $container_name $image_name"
            }
        }
        stage('Deploy to Artifactory'){
            agent {
                label "slave_maven_build"
            }
            steps {
                // Push to Dockerhub repo
               // withCredentials([usernamePassword(credentialsId: 'Artifactory_admin', passwordVariable: 'repo_passw', usernameVariable: 'repo_username')]) {
                    sh "echo \"${ARTIFACTORY_CRED_PSW}\" | docker login -u \"${ARTIFACTORY_CRED_USR}\" docker-virtual.artifactory --password-stdin"
                    sh "docker tag ${params.image_name} docker-virtual.artifactory/${params.image_name}"
                    sh "docker push docker-virtual.artifactory/${params.image_name}"
                //}
            }
        }
        stage('Clean image pushed to Artifactory'){
            agent {
                label "slave_maven_deploy"
            }
                    steps {
                        // Delete the image pushed to Dockehub
                        // Clean old images
                        sh "chmod +x ./cleanup.sh && ./cleanup.sh "
                        sh "docker rmi --force docker-virtual.artifactory/${params.image_name}"
                    }
                }
        stage('Deploy to App'){
            agent {
                label "slave_maven_deploy"
            }
            steps {
                // Push to Dockerhub repo
                //withCredentials([usernamePassword(credentialsId: 'ae4a797f-6a03-4dc7-874f-c6683cc2fcba', passwordVariable: 'repo_passw', usernameVariable: 'repo_username')]) {
                    sh "echo \"${ARTIFACTORY_CRED_PSW}\" | docker login -u \"${ARTIFACTORY_CRED_USR}\" docker-virtual.artifactory --password-stdin"
                   // sh "docker tag $image_name savaonu/$image_name"
                    sh "docker pull docker-virtual.artifactory/${params.image_name}"
                     // Create container
                    sh "docker run -p 8089:8080 -d --name ${params.container_name} docker-virtual.artifactory/${params.image_name}"
                //}
            }
        }

        stage('Email'){
                    //agent {
                        // Run on windows node 
                      //  label "lin_node"
                    //}
                    steps {
                        // Info via email from windows node
                        emailext body: "<b>Project build successful</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", from: 'jenkins@test.com', mimeType: 'text/html', replyTo: '', subject: "SUCCESSFUL CI: Project name -> ${env.JOB_NAME}", to: "alexandru.sava@accesa.eu";
                    }
        }
    }
    post {
         failure {
                // Info via email about failed job
             sendEmail("Failed");
         }
        unsuccessful {  
              // Info via email about unsuccessful job 
            sendEmail("Unsuccessful");
        } 
    }
}
def sendEmail(status) {
    mail body: "<b>Project build </b>" + "<b>$status</b>"   + "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", charset: 'UTF-8', from: 'jenkins@test.com', mimeType: 'text/html', replyTo: '', subject: status + "  CI: Project name -> ${env.JOB_NAME}", to: "alexandru.sava@accesa.eu";
} 