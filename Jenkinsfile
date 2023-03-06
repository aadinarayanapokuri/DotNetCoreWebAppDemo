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
  AWS_ECS_SERVICE = 'demo_service'
  AWS_ECS_TASK_DEFINITION = 'demo'
  AWS_ECS_COMPATIBILITY = 'FARGATE'
  AWS_ECS_NETWORK_MODE = 'awsvpc'
  AWS_ECS_CPU = '256'
  AWS_ECS_MEMORY = '512'
  AWS_ECS_CLUSTER = 'demo'
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
    stage('Deploy to ECS') {
            steps {
                script {
                    def ecsParams = [
                        region: AWS_DEFAULT_REGION,
                        cluster: AWS_ECS_CLUSTER,
                        service: AWS_ECS_SERVICE,
                        image: "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/$IMAGE_TAG",
                        forceNewDeployment: true
                    ]
                    ecsDeployUpdate(serviceParams: ecsParams)
                }
            }
        }
 }
  /* stage('Deploy in ECS') {
  steps {
      script {
        sh("aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions file://${AWS_ECS_TASK_DEFINITION_PATH}")
        def taskRevision = sh(script: "aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} | egrep \"revision\" | tr \"/\" \" \" | awk '{print \$2}' | sed 's/\"\$//'", returnStdout: true)
        sh("aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskRevision}")
      }
      }
    } */
   post {
        always {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                sh "aws ecs update-service --region ${AWS_DEFAULT_REGION} --cluster $ECS_CLUSTER --service $ECS_SERVICE --desired-count 1"
            }
          }
        }
   
}
