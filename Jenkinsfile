pipeline {
    agent any

    environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-creds')
    AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
    TF_WORKSPACE = 'dev'
    }

 parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment to deploy')
  }

  stages {
    stage('Set AWS Credentials') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          script {
            // Now the AWS credentials are available for Terraform commands
            echo "AWS credentials set for use"
          }
        }
      }
    }

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/your/repo.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir("terraform/${params.ENV}") {
          withCredentials([
            string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
          ]) {
            sh 'terraform init'
          }
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        dir("terraform/${params.ENV}") {
          sh 'terraform validate'
        }
      }
    }

    stage('Select Workspace') {
      steps {
        dir("terraform/${params.ENV}") {
          sh """
            terraform workspace new ${params.ENV} || terraform workspace select ${params.ENV}
          """
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("terraform/${params.ENV}") {
          sh 'terraform plan -out=tfplan'
        }
      }
    }

    stage('Approval (for prod)') {
      when {
        expression { return params.ENV == 'prod' }
      }
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          input message: "Apply Terraform changes to PROD?"
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir("terraform/${params.ENV}") {
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }
  }
}
