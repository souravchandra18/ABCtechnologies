pipeline {
    agent any

    tools {
        maven 'maven-3.6.3'
    }
    environment {
        MAVEN_OPTS = "--add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED"
    }
    
    stages {
        
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/souravchandra18/ABCtechnologies.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
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
                script {
                    sh '''
                    docker build -t souravchandra18/tomcat-app:latest . 
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push souravchandra18/tomcat-app:latest
                    '''
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    sh '''
                    ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f kubernetes/deployment.yml
                kubectl apply -f kubernetes/service.yml
                '''
            }
        }
    }
}
