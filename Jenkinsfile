pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'my-id' // ID Jenkins Credentials
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
            agent {
                docker {
                    image 'python:3.10'
                }
            }
            steps {
                dir('Backend/odc') {
                    sh '''
                        python -m venv venv
                        . venv/bin/activate
                        pip install --no-cache-dir -r requirements.txt
                        python manage.py test
                    '''
                }
            }
        }

        stage('Build & Test Frontend (React)') {
            steps {
                dir('Frontend') {
                    echo "⚙️ Installation et test du frontend React"
                    sh '''
                        export PATH=$PATH:/var/lib/jenkins/.nvm/versions/node/v22.15.0/bin/
                        npm install
                        npm run build
                        # npm test -- --watchAll=false
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    echo "🐳 Construction de l'image Docker Backend"
                    sh "docker build -t ${DOCKERHUB_USER}/mon-backend:latest -f ./Backend/odc/Dockerfile ./Backend/odc"

                    echo "🐳 Construction de l'image Docker Frontend"
                    sh "docker build -t ${DOCKERHUB_USER}/mon-frontend:latest ./Frontend"
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                echo "🚀 Envoi des images Docker sur Docker Hub"
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_USER/mon-backend:latest
                        docker push $DOCKER_USER/mon-frontend:latest
                    '''
                }
            }
        }

        stage('run') {
            steps {
                sh '''
                    docker-compose build
                    docker-compose up -d
                '''
            }
        }
    }

    post {
        success {
            mail to: 'juloballer19@gmail.com',
                 subject:"🚀 Déploiement réussi",
                 body: "✅ L'application a été déployée avec succès !"
        }
        failure {
            mail to: 'juloballer19@gmail.com',
                 subject:"❌ Échec du déploiement",
                 body: "⚠️ Le pipeline a échoué. Merci de corriger les erreurs."
        }
    }
}
