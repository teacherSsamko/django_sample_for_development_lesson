pipeline {
    agent any

    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('NCR_CREDENTIAL')
    }
    
    stages {
        stage('Checkout') {
            steps {
                // 소스 코드 체크아웃
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Docker 이미지 빌드 및 푸시
                script {
                    def imageName = "lion-app"
                    def imageTag = "jenkins-latest"
                    def dockerRegistry = "lion-cr.kr.ncr.ntruss.com"

                    docker.build("${dockerRegistry}/${imageName}:${imageTag}", ".")

                    docker.withRegistry("${dockerRegistry}", 'docker-credentials-id') {
                        docker.image("${imageName}:${imageTag}").push()
                    }
                }
            }
        }
    }
}
