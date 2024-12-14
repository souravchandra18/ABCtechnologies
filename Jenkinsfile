pipeline {
    agent any
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
                sh 'docker tag demo-app:latest 149536492184.dkr.ecr.us-east-1.amazonaws.com/demo-app:latest'
                sh 'docker push 149536492184.dkr.ecr.us-east-1.amazonaws.com/demo-app:latest'
            }
        }
    }
}
