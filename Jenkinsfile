pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'my-id' // ID Jenkins Credentials
        DOCKERHUB_USER = 'julo1997'      // ton nom d'utilisateur Docker Hub
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📥 Clonage du dépôt Git"
                checkout scm
            }
        }

        stage('Setup Node') {
            steps {
                script {
                    // Installation de Node.js si nécessaire
                    sh '''
                        if ! command -v node &> /dev/null; then
                            echo "Node.js non trouvé, installation en cours..."
                            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
                            export NVM_DIR="$HOME/.nvm"
                            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                            nvm install 18
                        fi
                        node --version
                        npm --version
                    '''
                }
            }
        }

        stage('Build & Test Frontend (React)') {
            steps {
                dir('Frontend') {
                    echo "⚙️ Installation et test du frontend React"
                    sh '''
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
                        docker push ${DOCKERHUB_USER}/mon-backend:latest
                        docker push ${DOCKERHUB_USER}/mon-frontend:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Déploiement de l'application"
                sh '''
                    docker-compose down || true
                    docker-compose build
                    docker-compose up -d
                '''
            }
        }
    }

    post {
        always {
            script {
                // Nettoyage des containers
                sh 'docker-compose down || true'
            }
        }
        success {
            mail to: 'doguepauljoseph@gmail.com',
                 subject: "Déploiement réussi",
                 body: "L'application a été déployée avec succès"
        }
        failure {
            mail to: 'doguepauljoseph@gmail.com',
                 subject: "Échec du déploiement",
                 body: "Veuillez corriger les erreurs dans le pipeline"
        }
    }
}