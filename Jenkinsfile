pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('1')
        AWS_CREDENTIALS = credentials('2')
        IMAGE_NAME = 'kunalpanjwani2001/dotnet-hello-world'
    }

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['UAT', 'Production'], description: 'Choose environment')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Panjwani-kunal/dotnet-hello-world'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${env.BUILD_ID}").push()
                    }
                }
            }
        }

        stage('Deploy to AWS EC2') {
            environment {
                EC2_IP = (params.DEPLOY_ENV == 'UAT') ? '44.201.211.154' : '44.201.211.167'
                SSH_CREDENTIALS_ID = (params.DEPLOY_ENV == 'UAT') ? '3' : '4'
            }
            steps {
                sshagent(credentials: [SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${EC2_IP} \
                    'docker pull ${IMAGE_NAME}:${env.BUILD_ID} && \
                     docker run -d -p 80:80 ${IMAGE_NAME}:${env.BUILD_ID}'
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
