pipeline {
  agent {
    kubernetes {
      inheritFrom 'kube-agent'
      yaml '''
      spec:
        containers:
        - name: terraform
          image: hashicorp/terraform:latest
'''
//        containerTemplate {
//          name 'terraform'
//          image 'hashicorp/terraform:latest'
//          command 'sleep'
//          args '99d'

  }
}
environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
      stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://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@github.com/roniecv/jenkins-eks.git"
                        }
                    }
                }
            }

      stage('TF Init&Plan') {
        container('terraform') {
          steps {
              sh 'terraform init -upgrade'
              sh 'terraform plan'  
          }
      }
    }
      stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
      }  
    } 
  }
}
