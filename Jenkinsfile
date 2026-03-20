pipeline {
    agent any
    parameters {
        string(name: 'IMAGE_NAME', description: 'ENTER THE IMAGE NAME!')
        string(name: 'IMAGE_TAG', description: 'ENTER THE IMAGE TAG!')
    }
    stages {
        stage {
            steps('Checkout') {
                sh """
                echo 'Checking out git main branch'
                git branch: 'main', url:'https://github.com/lovelu99/config-repo.git'
                """
            }
        }
        stage {
            steps('Update Image Tag') {
                sh """
                echo 'Update images Tag'
                if (${IMAGE_NAME}=='noakhali/todo-frontend') {
                    echo 'update'
                }
                else if (${IMAGE_NAME}=='noakhali/todo-backtend'){
                    echo 'back'
                }

                """
            }
        }
    }
}