pipeline {
    agent any
    stages {
        stage ('SCM checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SaiAshish-Konchada/SFTS-Jenkins-Test.git'
            }
        }
        stage ('docker image build') {
            steps {
                script {
                    def imageName = 'saiashishkonchada/secure-file-tranfer-image'
                    docker.image(imageName).build("-t $imageName .")
                }
            }
        }
        stage ('docker login') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKERHUB_CREDENTIALS')]) {
                    sh "echo \${DOCKERHUB_CREDENTIALS} | docker login -u saiashishkonchada --password-stdin"
                }
            }
        }
        stage ('docker image push') {
            steps {
                script {
                    def imageName = 'saiashishkonchada/secure-file-transfer-image'
                    docker.image(imageName).push()
                }
            }
        }
        stage ('get the confirmation from user') {
            steps {
                input 'Do you want to deploy this application?'
            }
        }
        stage ('Deploy using Docker Compose') {
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
