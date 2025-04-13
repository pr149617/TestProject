pipeline {
    agent any

    environment {
        GIT_TOKEN = credentials('git-auth')
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-auth')
    }

    stages {
        stage('Git Checkout') {
            steps {
               git "https://github.com/pr149617/TestProject.git"
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?"
                sh '''
                    terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        always {
            // No need to clean up gcp-key.json, as we aren't creating it anymore
        }
    }
}
