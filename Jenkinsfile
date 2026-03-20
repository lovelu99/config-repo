pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_NAME', description: 'ENTER THE IMAGE NAME!')
        string(name: 'IMAGE_TAG', description: 'ENTER THE IMAGE TAG!')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out git main branch'
                git branch: 'main', url: 'https://github.com/lovelu99/config-repo.git'
            }
        }

        stage('Update Image Tag') {
            steps {
                script {
                    if (params.IMAGE_NAME == 'noakhali/todo-frontend') {
                        sh """
                            echo "Updating frontend image"
                            sed -i 's|^ *image:.*|  image: ${params.IMAGE_NAME}:${params.IMAGE_TAG}|g' ./manifest/frontend-1-deployment.yaml
                            cat ./manifest/frontend-1-deployment.yaml
                        """
                    } else if (params.IMAGE_NAME == 'noakhali/todo-backend') {
                        sh """
                            echo "Updating backend image"
                            sed -i 's|^ *image:.*|  image: ${params.IMAGE_NAME}:${params.IMAGE_TAG}|g' ./manifest/backend-1-deployment.yaml
                        """
                    } else {
                        error "Unknown image name: ${params.IMAGE_NAME}"
                    }
                }
            }
        }
    }
}