FROM jenkins/jenkins:lts

# Installe Docker
USER root
RUN apt-get update && apt-get install -y docker.io
USER jenkins
