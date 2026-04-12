pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/bharathidevopspro/ci-cd-project-.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform/main-project') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform/main-project') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Wait for EC2') {
            steps {
                sh 'sleep 120'
            }
        }

        stage('Run Ansible') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory/aws_ec2.yml playbook.yml'
                }
            }
        }
    }
}
