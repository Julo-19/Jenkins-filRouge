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
                withDockerRegistry([credentialsId: 'my-id', url: 'https://index.docker.io/v1/']) {
                    sh '''
                        export PATH=$PATH:/usr/local/bin
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
                    docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            mail to: 'votre.email@gmail.com',
                 subject: "Succès du déploiement",
                 body: "L'application a été déployée avec succès."
        }
        failure {
            echo 'Le déploiement a échoué.'
        }
    }
}
