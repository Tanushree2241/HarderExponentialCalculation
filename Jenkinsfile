pipeline {
    agent any

    environment {
        // Jenkins runs with a small PATH, so add the tool folders explicitly
        PATH = "/Users/mmacedo/.docker/bin:/usr/local/bin:/opt/homebrew/bin:${env.PATH}"

        // Folder in the repo that contains Dockerfile, expo.c and Job.yaml.
        // Use 'exponential_example' if they are in that subfolder,
        // or '.' if they are at the top level of the repo.
        APP_DIR = '.'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'git@github.com:marianagmmacedo/expo.git'
            }
        }
        stage('Show files') {
            steps {
                dir("${APP_DIR}") {
                    sh 'pwd && ls -la'
                }
            }
        }

        stage('Build image') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -t expo:1.0 .'
                }
            }
        }

        stage('Run a test') {
            steps {
                sh '''
                    out=$(docker run --rm expo:1.0 2 10)
                    echo "Got:      $out"
                    echo "Expected: 2 ^ 10 = 1024"
                    [ "$out" = "2 ^ 10 = 1024" ]
                '''
            }
        }

        stage('Kubernetes Job') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        minikube image load expo:1.0
                        kubectl delete job expo-job --ignore-not-found
                        kubectl apply -f Job.yaml
                        kubectl wait --for=condition=complete job/expo-job --timeout=60s
                        kubectl logs job/expo-job
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'kubectl delete job expo-job --ignore-not-found || true'
        }
    }
}