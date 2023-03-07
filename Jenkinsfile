pipeline {  
 agent any  
 environment {  
  dotnet = 'C:\\Program Files\\dotnet\\dotnet.exe' 
  DATE = new Date().format('yy.M')
  TAG = "${DATE}.${BUILD_NUMBER}"
  AWS_ACCOUNT_ID="670166063118"
  AWS_DEFAULT_REGION="ap-northeast-1"
  IMAGE_REPO_NAME="ecr"
  IMAGE_TAG="${DATE}.${BUILD_NUMBER}"
  REPOSITORY_URI = "670166063118.dkr.ecr.ap-northeast-1.amazonaws.com/ecr"
  AWS_ECR_REGION = 'ap-northeast-1'
  AWS_ECS_SERVICE = 'netcoreapp-service'
  AWS_ECS_TASK_DEFINITION = 'netcoreapp-td'
  AWS_ECS_COMPATIBILITY = 'FARGATE'
  AWS_ECS_NETWORK_MODE = 'awsvpc'
  AWS_ECS_CPU = '256'
  AWS_ECS_MEMORY = '512'
  AWS_ECS_CLUSTER = 'netcoreapp'
  AWS_ECS_TASK_DEFINITION_PATH = 'adi.json'
   }  
 stages {  
  stage('Logging into AWS ECR') {
            steps {
                script {
                sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
                 
            }
        }
  stage('Checkout') {  
   steps {
       git credentialsId: 'github-jenkins', url: 'git@github.com:aadinarayanapokuri/DotNetCoreWebAppDemo.git', branch: 'main'
   }  
  } 
 
stage('Docker') {
    steps {    
      script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        } 
        }            
        }
  stage('Pushing to ECR') {
     steps{  
         script {
                sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"""
                sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""
         }
        }
      }
  /*  stage('Deploy to ECS') {
            steps {
                script {
                    def ecsParams = [
                        region: AWS_DEFAULT_REGION,
                        cluster: AWS_ECS_CLUSTER,
                        service: AWS_ECS_SERVICE,
                        image: "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/$IMAGE_TAG",
                        forceNewDeployment: true
                    ]
                   
                }
            }
        }*/
  stage('Deploy in ECS') {
  steps {
      
        sh "aws ecs update-service --cluster netcoreapp --service netcoreapp-service --force-new-deployment"
      
      }
    }
}  
}
