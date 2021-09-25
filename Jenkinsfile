pipeline {
    agent any

    stages {
        stage ('Build Image') {
            steps {
                sh 'docker build --tag my-build .'
                sh 'docker images'
            }
        }
    }
}