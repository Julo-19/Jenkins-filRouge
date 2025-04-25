pipeline {
    agent any
     environment {
        DOCKER_HUB_CREDENTIALS = 'my-id' // ID Jenkins Credentials
        DOCKERHUB_USER = 'julo1997'       // ton nom d’utilisateur Docker Hub
    }
   stages {
        stage('Checkout') {
            steps {
                echo "📥 Clonage du dépôt Git"
                checkout scm
            }
        }  
    }
}