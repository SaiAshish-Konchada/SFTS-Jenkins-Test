pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Flask Frontend') {
            steps {
                script {
                    def flaskImage = docker.build('flask-frontend', './app')
                }
            }
        }

        stage('Build and Start PostgreSQL') {
            steps {
                script {
                    def postgresImage = docker.image('postgres:13').withRun('--name postgres -e POSTGRES_DB=secure_file_system -e POSTGRES_USER=ruegen -e POSTGRES_PASSWORD=ruegen -p 5432:5432') {
                        sleep 5
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def flaskContainer = docker.container(flaskImage.id).start()
                    def testResult = sh(script: 'curl -s http://localhost:5000', returnStatus: true)
                    if (testResult != 0) {
                        error "Frontend test failed"
                    }
                    // Deploy using docker-compose
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }
    }

    post {
        always {
            script {
                docker.image('flask-frontend').remove()
                docker.image('postgres:13').stop().remove(force: true)
                sh 'docker-compose -f docker-compose.yml down'
            }
        }
    }
}
