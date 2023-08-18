pipeline {
    agent any
    stages {
        stage('SCM checkout') {
            steps {
                deleteDir() // Clean workspace
                checkout scm
            }
        }
        stage('Docker image build') {
            steps {
                script {
                    def frontendImageName = "saiashishkonchada/secure-file-transfer-frontend:${BUILD_NUMBER}"
                    def frontendBuildContext = 'app'
                    def frontendDockerfile = 'Dockerfile'
                    echo "Building Docker image ${frontendImageName} from ${frontendDockerfile} in ${frontendBuildContext}"
                    docker.image(frontendImageName).build(context: frontendBuildContext, dockerfile: frontendDockerfile)

                    def backendImageName = "saiashishkonchada/secure-file-transfer-backend:${BUILD_NUMBER}"
                    def backendBuildContext = 'postgres'
                    def backendDockerfile = 'Dockerfile'
                    echo "Building Docker image ${backendImageName} from ${backendDockerfile} in ${backendBuildContext}"
                    docker.image(backendImageName).build(context: backendBuildContext, dockerfile: backendDockerfile)
                }
            }
        }
        stage('Docker login and push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKERHUB_CREDENTIALS')]) {
                    sh "echo \${DOCKERHUB_CREDENTIALS} | docker login -u saiashishkonchada --password-stdin"
                    sh "docker push saiashishkonchada/secure-file-transfer-frontend:${BUILD_NUMBER}"
                    sh "docker push saiashishkonchada/secure-file-transfer-backend:${BUILD_NUMBER}"
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
