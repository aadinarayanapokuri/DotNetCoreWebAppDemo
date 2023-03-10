pipeline {
    agent any
    environment {
       DATE = new Date().format('yy.M')
       AWS_ACCOUNT_ID="670166063118"
       AWS_DEFAULT_REGION="ap-northeast-1"
       IMAGE_REPO_NAME="ecr"
       IMAGE_TAG="${DATE}.${BUILD_NUMBER}"
       REPOSITORY_URI = "670166063118.dkr.ecr.ap-northeast-1.amazonaws.com/ecr"
       AWS_ECR_REGION = 'ap-northeast-1'
       ECS_SERVICE = 'dotnetcoreapp-service'
       ECS_CLUSTER = 'dotnetcoreapp-cluster'
       AWS_ECS_TASK_DEFINITION_PATH = 'task_definition.json'
       ECR_URL = '670166063118.dkr.ecr.ap-northeast-1.amazonaws.com/ecr'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Docker Build') {
            steps {
                sh "docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG ."
            }
        }
        stage('AWS ECR Login') {
            steps {
                script {
                sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
                 
            }
        }
        stage('Push to ECR') {
            steps {
               // withCredentials([awsEcr(credentialsId: 'your-aws-credentials-id', region: AWS_REGION)]) {
                    sh "docker tag $IMAGE_REPO_NAME:$IMAGE_TAG ${ECR_URL}/$IMAGE_REPO_NAME:$IMAGE_TAG"
                    sh "docker push ${ECR_URL}/$IMAGE_REPO_NAME:$IMAGE_TAG"
            }
        }
        stage('Update ECS Service') {
            steps {
               // withCredentials([awsEcs(credentialsId: 'your-aws-credentials-id', region: AWS_DEFAULT_REGION)]) {
                    sh "aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --image ${ECR_URL}/$IMAGE_REPO_NAME:$IMAGE_TAG"
                }
            }
        }
    }
