pipeline {
    agent {
        docker {
            image 'python:3.10' // image officielle Python
        }
    }

    environment {
        DOCKER_HUB_CREDENTIALS = 'my-id'
        DOCKERHUB_USER = 'julo1997'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📥 Clonage du dépôt Git"
                checkout scm
            }
        }

        stage('Build & Test Backend (Django)') {
            steps {
                dir('Backend/odc') {
                    echo "⚙️ Création de l'environnement virtuel et test de Django"
                    sh '''
                        python -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                    '''
                }
            }
        }
    }
}
