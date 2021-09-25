pipeline {
    agent {
        docker {
            image 'node:10'
        }
    }

    stages {
        stage ('Build Image') {
            steps {
                sh 'docker build --tag my-build .'
            }
        }
    }
}