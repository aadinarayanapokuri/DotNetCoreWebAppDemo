pipeline {  
 agent any  
 environment {  
  DATE = new Date().format('yy.M')
  AWS_ACCOUNT_ID="670166063118"
  AWS_DEFAULT_REGION="ap-northeast-1"
  IMAGE_REPO_NAME="ecr"
  //IMAGE_TAG="${DATE}.${BUILD_NUMBER}"
  TAG_NAME = "${BUILD_NUMBER}"
  IMAGE_TAG="23.3.30"
  REPOSITORY_URI = "670166063118.dkr.ecr.ap-northeast-1.amazonaws.com/ecr"
  AWS_ECR_REGION = 'ap-northeast-1'
  AWS_ECS_SERVICE = 'dotnetcoreapp-service'
  AWS_ECS_CLUSTER = 'dotnetcoreapp-cluster'
  AWS_ECS_TASK_DEFINITION_PATH = 'task_definition.json'
  ECR_URL = '670166063118.dkr.ecr.ap-northeast-1.amazonaws.com/ecr'
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
       git credentialsId: 'github-jenkins', url: 'https://github.com/aadinarayanapokuri/DotNetCoreWebAppDemo.git', branch: 'main'
   }  
  } 
 
stage('Docker') {
    steps {    
      script {
         // dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         //new changes start
          sh """
          echo TAG_NAME is ${TAG_NAME}
          docker build -t ${IMAGE_REPO_NAME}:${TAG_NAME} .
          docker tag ${IMAGE_REPO_NAME}:${TAG_NAME} ${REPOSITORY_URI}:${TAG_NAME}
          """
        // new changes end
        } 
        }            
        }
  stage('Pushing to ECR') {
     steps{  
         script {
                //sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"""
                // sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""

            // new changes start
               def dockerimage="${REPOSITORY_URI}:${TAG_NAME}"
               sh "docker push ${REPOSITORY_URI}:${TAG_NAME}"
               sh "docker pull ${REPOSITORY_URI}:${TAG_NAME}"
              //sh "sed -i 's|dockerimage|${dockerimage}|g' deployment.yml"
            // new chnages end
            
         }
        }
      }
 
  stage('Deploy in ECS') {
  steps {
  // sh "aws ecs register-task-definition --cli-input-json file://${AWS_ECS_TASK_DEFINITION_PATH}"
     sh "aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --force-new-deployment"
      
      }
    }
}  
}
