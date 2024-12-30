pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: true, description: 'Automatically run apply after generating plan?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '-u root:root --entrypoint=""'  // Disable entrypoint
        }
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    dir("terraform") {
                        git url: 'https://github.com/aishwarya-9patil/Terraform-Jenkins-automation.git', branch: 'main'
                    }
                }
            }
        }

        stage('Install Git') {
            steps {
                sh 'apt-get update && apt-get install -y git'  // Install Git
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }
}

