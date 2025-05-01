pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'Sonar-Jenkins'   // Nom de ton serveur Sonar dans Jenkins
        SONARQUBE_TOKEN = credentials('sonarScan')  // ID de ton credential
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
       
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    script {
                        def scannerHome = tool 'SonarScanner' // <- Ici on charge SonarScanner installé dans Jenkins
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                              -Dsonar.projectKey=jenkinsSonar \
                              -Dsonar.sources=. \
                              -Dsonar.host.url=http://localhost:9000 \
                              -Dsonar.token="${SONARQUBE_TOKEN}"
                        """
                    }
                }
            }
        }
    }
}
