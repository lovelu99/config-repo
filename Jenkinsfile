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
                    def fileName = ''

                    if (params.IMAGE_NAME == 'noakhali/todo-frontend') {
                        fileName = './manifest/frontend-1-deployment.yaml'
                    } else if (params.IMAGE_NAME == 'noakhali/todo-backend') {
                        fileName = './manifest/backend-1-deployment.yaml'
                    } else {
                        error "Unknown image name: ${params.IMAGE_NAME}"
                    }

                    sh """
                        echo "Updating image in ${fileName}"
                        sed -i "s|${params.IMAGE_NAME}:.*|${params.IMAGE_NAME}:${params.IMAGE_TAG}|g" ${fileName}
                        
                        echo "Updated file:"
                        cat ${fileName}
                    """
                }
            }
        }
    }
}