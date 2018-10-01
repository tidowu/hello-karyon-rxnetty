pipeline {

  agent any
  environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
        IMAGE_NAME = 'turtleracemiddle'
        REGISTRY = 'http://884956725745.dkr.ecr.us-east-1.amazonaws.com/kzn-rnd-hadr'
  }
  stages {
    stage('build app') {
      // Build jar file
      steps {
        sh './gradlew clean fatjar'
        archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
      }
    }
    stage('unit test'){
      steps{
        sh 'ls build/libs/'
      }
    }
    stage('build image') {
      // Build docker image and run test
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${env.BUILD_ID} .'
      }
    }
    stage('run image') {
      steps {
        sh 'docker run -ti ${IMAGE_NAME}:${env.BUILD_ID} --name ${IMAGE_NAME} -port 8080:8080'
        sh 'docker ps | grep ${IMAGE_NAME}'
      }
    }
    stage('publish to ECR') {
      steps {
        sh 'export AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_KEY_ID'
        sh 'export AWS_ACCESS_KEY_ID=$AWS_SECRET_ACCESS_KEY'
        sh 'aws ecr get-login --no-include-email --region us-east-1'
        sh 'docker tag ${IMAGE_NAME}:${env.BUILD_ID} ${REGISTRY}/${IMAGE_NAME}'
        sh 'docker push ${REGISTRY}/${IMAGE_NAME}'
      }
    }
    stage('Verify Publish') {
      steps {
        sh 'aws ecr list-images | grep ${IMAGE_NAME}'
      }
    }
    stage('deploy to us-east and us-west') {
      steps{
        when {
          expression {
            currentBuild.result == null || currentBuild.result == 'SUCCESS'
          }
        }
        steps{
          sh 'date'
        }

      }

    }
    stage('end2end test'){
      steps {
        sh 'date'
      }
    }
  }
}
