pipeline {
    agent {
        docker {
            image 'node:10'
        }
    }

    stages {
        stage ('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage ('Build'){
            steps{
                sh 'npm run ng build'
            }
        }
    }

    post {
        always {
            archiveArtifacts 'dist/'
        }
    }
}