pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages {
        stage('SCM checkout') {
            steps {
                deleteDir() // Clean workspace
                checkout scm
            }
        }
        stage('Build and Push Docker Images') {
            steps {
                script {
                    def frontendImageName = "saiashishkonchada/secure-file-transfer-frontend:${BUILD_NUMBER}"
                    def backendImageName = "saiashishkonchada/secure-file-transfer-backend:${BUILD_NUMBER}"

                    docker.image(frontendImageName).build(context: 'app', dockerfile: 'Dockerfile')
                    docker.image(backendImageName).build(context: 'postgres', dockerfile: 'Dockerfile')

                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        docker.image(frontendImageName).push()
                        docker.image(backendImageName).push()
                    }
                }
            }
        }
        stage('Get confirmation from user') {
            steps {
                input 'Do you want to deploy this application?'
            }
        }
        stage('Deploy using Docker Compose') {
            steps {
                sh 'docker-compose -f docker-compose.yml up -d'
            }
        }
    }
    post {
        always {
            script {
                sh 'docker-compose -f docker-compose.yml down'
            }
        }
    }
}
