pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_NAME', description: 'ENTER THE IMAGE NAME!')
        string(name: 'IMAGE_TAG', description: 'ENTER THE IMAGE TAG!')
    }
    environment {
        FILE_NAME = ''
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
                    def selectedFile = ''
                    if (params.IMAGE_NAME == 'noakhali/todo-frontend') {
                        selectedFile = './manifest/frontend-1-deployment.yaml'
                        echo "file name is ${selectedFile}"
                    } else if (params.IMAGE_NAME == 'noakhali/todo-backend') {
                        selectedFile = './manifest/backend-1-deployment.yaml'
                    } else {
                        error "Unknown image name: ${params.IMAGE_NAME}"
                    }
                    FILE_NAME = selectedFile
                    echo "file name is ${selectedFile}"
                    echo "env file name is ${FILE_NAME}"

                    sh """
                        echo "Updating image in ${FILE_NAME}"
                        sed -i "s|${params.IMAGE_NAME}:.*|${params.IMAGE_NAME}:${params.IMAGE_TAG}|g" ${FILE_NAME}
                        echo "Updated file:"
                        cat ${FILE_NAME}
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
                    git add ${FILE_NAME}
                    if git diff --cached --quiet; then
                            echo "No changes to commit"
                    else
                        git commit -m 'CI updated: image tag to ${params.IMAGE_TAG}' 
                        git push "https://\$GIT_USER:\$GIT_PASS@github.com/lovelu99/config-repo.git" main
                    fi
                    """
                }
            }
        }
    }
}