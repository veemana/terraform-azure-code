pipeline {
  agent {
    docker {
      image 'hashicorp/terraform:latest'
      args '--entrypoint="" -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
        s_id = credentials('subscription_id')
        c_id  = credentials('client_id')
        c_secret = credentials('client_secret')
        t_id = credentials('tenant_id')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/veemana/terraform-azure-code.git']]])
      }
    }

    stage('Terraform Init') {
      steps {
       sh 'yum install pip'
       sh 'pip install az'
       sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
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
