pipeline {
    agent any

    environment {
        DOCKER_USER = 'julo1997' // Remplace ceci par ton nom d'utilisateur Docker Hub
        BACKEND_IMAGE = "${DOCKER_USER}/projetfilrouge_backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/projetfilrouge_frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/projetfilrouge_migrate"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/Julo-19/Jenkins-filRouge.git'
            }
        }

        stage('Build des images') {
            steps {
                sh 'docker build -t $BACKEND_IMAGE:latest ./Backend/odc'
                sh 'docker build -t $FRONTEND_IMAGE:latest ./Frontend'
                sh 'docker build -t $MIGRATE_IMAGE:latest ./Backend/odc'
            }
        }

        stage('Push des images sur Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'my-id', url: '') {
                    sh 'docker push $BACKEND_IMAGE:latest'
                    sh 'docker push $FRONTEND_IMAGE:latest'
                    sh 'docker push $MIGRATE_IMAGE:latest'
                }
            }
        }

        stage('Déploiement local avec Docker Compose') {
            steps {
                sh '''
                    docker-compose down || true
                    docker-compose pull
                    docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            mail to: 'juloballe19r@gmail.com',
                 subject: "✅ Succès",
                 body: "L'application a été déployée avec succès !"
        }
        failure {
            mail to: 'juloballer19@gmail.com',
                 subject: "❌ Échec",
                 body: "Une erreur s’est produite pendant le pipeline Jenkins."
        }
    }
}
