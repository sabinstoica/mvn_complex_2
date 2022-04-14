pipeline {
    agent {label 'builder'}
    tools {maven "Maven3"}
stages {
            stage ('Get code from GIT') {
                steps {
                    // Get the repo from GitHub
                    git 'https://github.com/sabinstoica/mvn_complex_2.git'
                       }
            }
            stage('build') {
                 steps {
                     // build the package)
                      sh "mvn -f app/ clean package"
                       }
                 }
            stage('SonarQube analysis') {
                steps {
                withSonarQubeEnv('sonar2') { 
                sh "mvn -f app/ sonar:sonar"
            stage("Quality gate") {
                steps {
                    waitForQualityGate abortPipeline: true
                
            }
                                 }
                      }
             }
      }
   }
