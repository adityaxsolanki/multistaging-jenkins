pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment to deploy')
  }

  environment {
    TF_WORKSPACE = 'dev'
  }

  stages {
    stage('Set AWS Credentials') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-creds'
        ]]) {
          echo "AWS credentials have been securely set"
        }
      }
    }

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/adityaxsolanki/multistaging-jenkins.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir("terraform/${params.ENV}") {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-creds'
          ]]) {
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
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-creds'
          ]]) {
            sh 'terraform plan -out=tfplan'
          }
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
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-creds'
          ]]) {
            sh 'terraform apply -auto-approve tfplan'
          }
        }
      }
    }
  }
}
