pipeline {
    agent { docker { image 'python:3.11-alpine' } }
    stages {
        stage('build') {
            steps {
                sh 'python --version'
            }
        }
    }
}