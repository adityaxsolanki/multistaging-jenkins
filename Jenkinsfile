pipeline {
    agent any

    environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-creds')
    AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
  }
    environment {
        TF_ENV = "${env.BRANCH_NAME == 'main' ? 'prod' : 'dev'}"
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy production infrastructure?')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Branch: ${env.BRANCH_NAME}"
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Select Workspace') {
            steps {
                dir('terraform') {
                    script {
                        sh "terraform workspace select ${TF_ENV} || terraform workspace new ${TF_ENV}"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh "terraform plan -var='environment=${TF_ENV}'"
                }
            }
        }

        stage('Terraform Apply (Only for main/prod)') {
            when {
                branch 'main'
            }
            steps {
                dir('terraform') {
                    input message: "Apply to production?", ok: "Yes, apply"
                    sh "terraform apply -auto-approve -var='environment=prod'"
                }
            }
        }

        stage('Terraform Destroy (Manual & Prod Only)') {
            when {
                allOf {
                    branch 'main'
                    expression { return params.DESTROY == true }
                }
            }
            steps {
                dir('terraform') {
                    input message: "Destroy production resources?", ok: "Yes, destroy"
                    sh "terraform destroy -auto-approve -var='environment=prod'"
                }
            }
        }
    }
}
