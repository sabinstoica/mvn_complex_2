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
                     script
                     {
                      def mvnHome = tool 'Maven3'
                      sh 'uname -a'
                      sh 'mvn -version'
                      sh "'${mvnHome}/bin/mvn' -f app/ clean package"
                     }
                       }
                 }
            stage('SonarQube analysis') {
                steps {
                withSonarQubeEnv('sonar2') { 
                    script
                    {
                def mvnHome = tool 'Maven3'
                sh 'uname -a'
                sh 'mvn -version'
                sh "'${mvnHome}/bin/mvn' -f app/ sonar:sonar"
                    }
                                 }
                      }
             }
      }
   }
