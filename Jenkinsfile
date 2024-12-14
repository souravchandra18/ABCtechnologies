pipeline {
    agent any
    environment {
        AWS_CREDENTIALS = credentials('aws-credentials')
        DOCKER_CREDENTIALS = credentials('ecr-credentials')
        IMAGE_NAME = '149536492184.dkr.ecr.us-east-1.amazonaws.com/demo-app'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/souravchandra18/ABCtechnologies.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t demo-app:latest .'
            }
        }
        stage('Push Docker Image') {
            steps {
                sh """
                docker login -u $DOCKER_CREDENTIALS_USR -p $DOCKER_CREDENTIALS_PSW $AWS_CREDENTIALS_USR.dkr.ecr.us-east-1.amazonaws.com
                docker tag demo-app:latest $IMAGE_NAME:latest
                docker push $IMAGE_NAME:latest
                """
            }
        }
    }
}
