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

    stage('Build & Test Backend (Django)') {
        steps {
            dir('Backend/odc') {
                echo "⚙️ Création de l'environnement virtuel et test de Django"
                sh '''
                    python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                        python manage.py test
                    '''
                }
            }
        }
}