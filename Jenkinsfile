pipeline {
    agent any
    environment {
        AWS_CREDENTIALS = credentials('aws-credentials')
        DOCKER_CREDENTIALS = credentials('ecr-credentials')
        IMAGE_NAME = '149536492184.dkr.ecr.us-east-1.amazonaws.com/demo-app'
        ANSIBLE_INVENTORY = 'localhost,'  // Use localhost as the inventory for Ansible
        ANSIBLE_PYTHON_INTERPRETER = '/usr/bin/python2'
        KUBE_CONFIG = credentials('kube-config')  // Kubernetes config credential
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
                docker login -u ${DOCKER_CREDENTIALS_USR} -p ${DOCKER_CREDENTIALS_PSW} 149536492184.dkr.ecr.us-east-1.amazonaws.com
                docker tag demo-app:latest $IMAGE_NAME:latest
                docker push $IMAGE_NAME:latest
                """
            }
        }
        stage('Deploy with Ansible') {
            steps {
                script {
                    sh '''
                    ansible-playbook -i "localhost," -c local ansible/playbook.yml
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig(credentialsId: 'kube-config') {
                        sh 'kubectl apply -f kubernetes/deployment.yml'
                        sh 'kubectl apply -f kubernetes/service.yml'
                    }
                }
            }
        }
    }
}
