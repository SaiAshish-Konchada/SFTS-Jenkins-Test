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
                        sh 'docker-compose build'
                    }
        }    
        stage ('docker login') {
            steps {
                sh 'echo dckr_pat_TFcEvVfbxV-jpQQgyWX1wH0vqvQ | /usr/bin/docker login -u saiashishkonchada --password-stdin'
            }
        }
        stage ('docker image push') {
            steps {
                sh 'docker image push saiashishkonchada/securefrontend'
            }
        }
        stage ('get the confirmation from user') {
            steps {
                input 'Do you want to deploy this application?'
            }
        }
        stage ('remove existing service') {
            steps {
                sh 'docker-compose down'
            }
        }
        stage ('create docker service') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}
