pipeline {
  agent {
    docker {
      image 'terraform:latest'
      args '--entrypoint="" -v ${HOME}/.ssh:/root/.ssh'
    }
  }

  environment {
        s_id = credentials('subscription_id')
        c_id  = credentials('client_id')
        c_secret = credentials('client_secret')
        t_id = credentials('tenant_id')
        AZURE_CLI_VERSION = "2.26.1"
  }

  stages {
    stage('Install Azure CLI') {
            steps {
                sh "curl -sL https://aka.ms/InstallAzureCLIDeb | sh"
            }
        }

    stage('Configure PATH') {
            steps {
                sh "export PATH=$PATH:/usr/local/bin"
            }
        }
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/veemana/terraform-azure-code.git']]])
      }
    }

    stage('Terraform Init') {
      steps {
       sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh "az --version" // Verify that Azure CLI is installed
        sh 'terraform plan -var "subscription_id1=${env:s_id}" -var "client_id1=${env:c_id}" -var "client_secret1=${env:c_secret}" -var "tenant_id1=${env:t_id}"'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -var "subscription_id1=${env:s_id}" -var "client_id1=${env:c_id}" -var "client_secret1=${env:c_secret}" -var "tenant_id1=${env:t_id}" -auto-approve'
      }
    }
  }
}
