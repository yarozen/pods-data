pipeline {
    //agent any
    agent {
        kubernetes {
        label 'jenkinsrun'
        defaultContainer 'builder'
        yaml """
    kind: Pod
    metadata:
    name: kaniko
    spec:
    containers:
    - name: builder
        image: gcr.io/kaniko-project/executor:debug
        imagePullPolicy: Always
        command:
        - /busybox/cat
        tty: true
        volumeMounts:
        - name: docker-config
            mountPath: /kaniko/.docker
    volumes:
        - name: docker-config
        configMap:
            name: docker-config
    """
        }
    }
    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'

                script {
                    def customImage = docker.build("my-image:${env.BUILD_ID}")
                    customImage.push()
                }
            }
        }
    }
}