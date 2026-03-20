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
        stage('Push to Github') {
            steps {
                   withCredentials([usernamePassword(
                    credentialsId: 'github-token',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                    )]) {
                    sh"""
                    git config user.email "jenkins@myorg.com"
                    git config user.name "Jenkins CI"
                    git checkout main
                    git add ${fileName}
                    git commit -m 'CI updated: image tag to ${IMAGE_TAG}' 
                    git push "https://\$GIT_USER:\$GIT_PASS@github.com/lovelu99/config-repo.git" main

                    """
                }
            }
        }
    }
}