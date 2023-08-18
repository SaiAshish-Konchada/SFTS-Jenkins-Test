pipeline {
    agent any
    stages {
        stage('SCM checkout') {
            steps {
                script {
                    // Clean workspace before checking out
                    deleteDir()
                    git branch: 'main', url: 'https://github.com/SaiAshish-Konchada/SFTS-Jenkins-Test.git'
                }
            }
        }
        stage('Docker image build') {
            steps {
                script {
                    def imageName = 'saiashishkonchada/secure-file-transfer-image'
                    docker.build(imageName, '.')
                }
            }
        }
        stage('Docker login and push') {
            steps {
                script {
                    def imageName = 'saiashishkonchada/secure-file-transfer-image'
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKERHUB_CREDENTIALS')]) {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                            sh "echo \${DOCKERHUB_CREDENTIALS} | docker login -u saiashishkonchada --password-stdin"
                            docker.image(imageName).push()
                        }
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
                script {
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
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
