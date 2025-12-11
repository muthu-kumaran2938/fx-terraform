pipeline {
    agent any

    environment {
        ENV = "${env.BRANCH_NAME}"
        TF_WORKDIR = "environments/${env.BRANCH_NAME}"
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'git@github.com:muthu-kumaran2938/fx-terraform.git',
                    branch: "${env.BRANCH_NAME}",
                    credentialsId: 'git-ssh-key'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKDIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKDIR}") {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                    sh 'cat tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                expression { env.BRANCH_NAME == 'production' }
            }
            steps {
                input message: "Approve the deployment to production?", ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.BRANCH_NAME != 'plan-only' }
            }
            steps {
                dir("${TF_WORKDIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
