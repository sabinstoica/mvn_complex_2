pipeline {
    agent {
            label "lin_node"
        }

    stages {
        stage('Fetch Git') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/Savaonu/maven_app'
            }
        }
        
        stage('Maven build') {
            steps {
                script {
        
                    //sh "mvn deploy -f artifactory-maven-plugin-example/ -s artifactory-maven-plugin-example/settings.xml"
                    // sh "mvn deploy -f app/ -Dusername=admin1 -Dpassword=password1 -D${env.BUILD_NUMBER}"
                     sh "mvn package deploy:deploy-file -DpomFile=app/pom.xml -Dfile=app/art-build-deploy.sh -Durl=http://172.30.69.154:8081/artifactory/maven_repo/"
                }
            }
        }
        
        
        
        stage('Test') {
            steps {
                script {
                    def mvnHome = tool 'Maven 3.6.3'
                     sh "'${mvnHome}/bin/mvn' -f app/ test"
                    //sh "/usr/share/maven/bin/mvn -f app/ test"
                }
           }
            
        }
        stage('Build') {
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
        }
        stage('Create Container') {
            steps {
                // Build Image
                sh "docker build -t $image_name ."

                // Create container
                sh "docker run -p 8089:8080 -d --name $container_name $image_name"
            }
        }
        stage('Deploy to Dockerhub'){
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
                    steps {
                        // Delete the image pushed to Dockehub
                        sh "docker rmi --force savaonu/$image_name"
                    }
                }
        stage('Send email') {
            steps {
                emailext body: 'Build Successful',
                subject: 'Build Successful',
                to: 'alexandru.sava@accesa.eu'
            }
        }
    }
}
