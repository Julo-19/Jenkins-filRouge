pipeline {
    agent any

    environment {
        DOCKER_USER = 'julo1997'
        BACKEND_IMAGE = "${DOCKER_USER}/projetfilrouge_backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/projetfilrouge_frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/projetfilrouge_migrate"
        DOCKER_HOST = 'unix:///var/run/docker.sock'
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'master', url: 'https://github.com/Julo-19/Jenkins-filRouge'
            }
        }

stage('Analyse SonarQube') {
    steps {
        withSonarQubeEnv('Sonar-Jenkins') { // Le nom doit correspondre à celui défini dans Jenkins > Configure System
            sh '''
                cd Backend/odc
                python3 -m venv venv
                . venv/bin/activate
                pip install -r requirements.txt
                pip install coverage
                coverage run -m unittest discover
                coverage xml
                Sonar-Jenkins
            '''
        }
    }
}


        stage('Build des images') {
            steps {
                sh '''
                    export PATH=$PATH:/usr/local/bin
                    docker build -t ${BACKEND_IMAGE}:latest ./Backend/odc
                    docker build -t ${FRONTEND_IMAGE}:latest ./Frontend
                    docker build -t ${MIGRATE_IMAGE}:latest ./Backend/odc
                '''
            }
        }

      stage('Push des images sur Docker Hub') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'my-id', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
            sh '''
                export PATH=$PATH:/usr/local/bin
                echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                docker push ${BACKEND_IMAGE}:latest
                docker push ${FRONTEND_IMAGE}:latest
                docker push ${MIGRATE_IMAGE}:latest
            '''
        }
    }
}


        stage('Déploiement local avec Docker Compose') {
            steps {
                sh '''
                    export PATH=$PATH:/usr/local/bin
                    docker-compose down || true
                    docker-compose pull
                    docker-compose rm -f backend_app || true
                    docker-compose up -d --build
                '''
            }
        }
    }

    // post {
    //     success {
    //         mail to: 'votre.email@gmail.com',
    //              subject: "Succès du déploiement",
    //              body: "L'application a été déployée avec succès."
    //     }
    //     failure {
    //         echo 'Le déploiement a échoué.'
    //     }
    // }


    
}
