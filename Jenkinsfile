pipeline {
    agent {
            label "lin_node"
        }
    environment {
        DOCKER_HUB_CRED = credentials('docker_cred')
    }
    parameters {
        string(name: 'image_name', defaultValue: 'maven_image', description: 'Name of the image')
        string(name: 'container_name', defaultValue: 'my_maven_app', description: 'Name of the container')
        string(name: 'sonar_token', defaultValue: 'aca9fee4aae893fa63b46476fb1938ddaac62ed9', description: 'The token from Sonarqube')
        string(name: 'sonar_srv', defaultValue: 'http://172.30.76.152:9000', description: 'The Sonarqube server')

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
                    sh "'${mvnHome}/bin/mvn' -f app/ package deploy -f app/ -Dusername=admin -Dpassword=password -D${env.BUILD_NUMBER}"
                     // sh "mvn -f app/ package deploy:deploy-file -DpomFile=app/pom.xml -Dfile=app/art-build-deploy.sh -Durl=http://172.30.69.154:8081/artifactory/maven_repo/"
                }
            }
        }
        
        
        
        /*stage('Test') {
            agent {
                label "lin_node"
            }
            steps {
                script {
                    def mvnHome = tool 'Maven 3.6.3'
                     sh "'${mvnHome}/bin/mvn' -f app/ test"
                    //sh "/usr/share/maven/bin/mvn -f app/ test"
                }
           }
            
        }
        stage('Build') {
            agent {
                label "lin_node"
            }
            steps {
                script {
                    // Create package
                    def mvnHome = tool 'Maven 3.6.3'
                    sh "'${mvnHome}/bin/mvn' -f app/ package"
    
                    // Clean old images
                    sh "chmod +x ./cleanup.sh && ./cleanup.sh "
                }
                
            }

            //post {
                // Archive the war file 
            //    success {
                    
            //        archiveArtifacts 'app/target/*.war'
            //    }
            //}
        } */
        stage('Create Container') {
            agent {
                label "slave_maven_build"
            }
            steps {
                // Build Image
                sh "docker build -t ${params.image_name} ."
                sh "mvn -f app/ sonar:sonar -Dsonar.host.url=${params.sonar_srv} -Dsonar.login=${params.sonar_token}"

                // Create container
               // sh "docker run -p 8089:8080 -d --name $container_name $image_name"
            }
        }
        stage('Deploy to Dockerhub'){
            agent {
                label "slave_maven_build"
            }
            steps {
                // Push to Dockerhub repo
                withCredentials([usernamePassword(credentialsId: 'ae4a797f-6a03-4dc7-874f-c6683cc2fcba', passwordVariable: 'repo_passw', usernameVariable: 'repo_username')]) {
                    sh "echo \"$repo_passw\" | docker login -u \"$repo_username\" --password-stdin"
                    sh "docker tag $image_name savaonu/$image_name"
                    sh "docker push savaonu/$image_name"
                }
            }
        }
        stage('Clean image pushed to Dockerhub'){
            agent {
                label "slave_maven_deploy"
            }
                    steps {
                        // Delete the image pushed to Dockehub
                        // Clean old images
                        sh "chmod +x ./cleanup.sh && ./cleanup.sh "
                        sh "docker rmi --force ${DOCKER_HUB_CRED_USR}/${params.image_name}"
                    }
                }
        stage('Deploy to App'){
            agent {
                label "slave_maven_deploy"
            }
            steps {
                // Push to Dockerhub repo
                withCredentials([usernamePassword(credentialsId: 'ae4a797f-6a03-4dc7-874f-c6683cc2fcba', passwordVariable: 'repo_passw', usernameVariable: 'repo_username')]) {
                    sh "echo \"$repo_passw\" | docker login -u \"$repo_username\" --password-stdin"
                   // sh "docker tag $image_name savaonu/$image_name"
                    sh "docker pull ${DOCKER_HUB_CRED_USR}/${params.image_name}"
                     // Create container
                    sh "docker run -p 8089:8080 -d --name ${params.container_name} ${DOCKER_HUB_CRED_USR}/${params.image_name}"
                }
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