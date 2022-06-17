#!groovy

// pipeline {
//     agent any
//     stages {
//         stage('Build image') {
//             steps {
//                 echo 'Starting to build docker image'

//                 script {
//                     def customImage = docker.build("my-image:${env.BUILD_ID}")
//                     customImage.push()
//                 }
//             }
//         }
//     }
// }


def podLabel = "kaniko-${UUID.randomUUID().toString()}"

pipeline {
    agent {
        kubernetes {
            label podLabel
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins-build: app-build
    some-label: "build-app-${BUILD_NUMBER}"
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:v1.5.1-debug
    imagePullPolicy: IfNotPresent
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-credentials
          items:
            - key: .dockerconfigjson
              path: config.json
"""
        }
    }

    stages {

        // stage('Checkout Code') {
        //     steps {
        //       checkout scm
        //     }
        // }

        stage('Build with Kaniko') {
          steps {
            container(name: 'kaniko', shell: '/busybox/sh') {
              withEnv(['PATH+EXTRA=/busybox']) {
                sh '''#!/busybox/sh -xe
                  /kaniko/executor \
                    --dockerfile Dockerfile \
                    --context `pwd`/ \
                    --verbosity debug \
                    --insecure \
                    --skip-tls-verify \
                    --destination yarozen/pods-data:0.0.1 \
                    --destination yarozen/pods-data:latest
                '''
              }
            }
          }
        }

    }
}