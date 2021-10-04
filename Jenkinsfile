pipeline {
    agent {
        kubernetes {
            defaultContainer 'worker'
            yaml """
kind: Pod
metadata:
  name: worker
spec:
  containers:
  - name: worker
    image: bharathpantala/jenkins-agent:latest
    imagePullPolicy: "IfNotPresent"
    command:
    - cat
    tty: true
    volumeMounts:
      - name: dockersock
        mountPath: "/var/run/docker.sock"
  restartPolicy: Never
  volumes:
      - name: dockersock
        hostPath:
          path: "/var/run/docker.sock"
"""
        }
    }
    environment {
        DOCKER_ACCOUNT_ID="bharathpantala"
        IMAGE_REPO_NAME="app-info"
        IMAGE_TAG="v2021.10"
        REPOSITORY_URI = "docker.io/${DOCKER_ACCOUNT_ID}/${IMAGE_REPO_NAME}"
        DOCKER_CREDS_ID = "cr-registry"
    }

    stages {
        // Building Docker images
        stage('Checkout SCM') {
            steps {
                git branch: 'master-ci-branch',
                    credentialsId: 'cr-ssh-git-keys',
                    url: 'git@github.com:cloudrural/app-info.git'

            }
        }
        stage('Compile') {
            steps{
                script {
                sh "mvn clean install"
                }
            }
        }
        stage('Test') {
            steps{
                script {
                sh "mvn test"
                }
            }
        }
        stage('Package') {
            steps{
                script {
                sh "mvn package"
                }
            }
        }
        stage('Deploy') {
            steps{
                script {
                sh "cp -prf ./tomcat/ ./install/"
                sh "cp -prf ./target/App-Info-release/ ./install/webapps/App-Info-release/"
                sh "cp -prf ./install/ ./staging/docker/install/"
                }
            }
        }
        stage('Build Docker Image') {
            steps{
                script {
                sh "docker build -t bharathpantala/app-info:v2021.10 -f ./staging/docker/Dockerfile"
                }
            }
        }
        stage('Pushing Docker Image') {
            steps {
              withCredentials([usernamePassword(credentialsId: '${DOCKER_CREDS_ID}', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "docker login -u $username -p $password"
                sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
              }
            }
        }
    }
}
