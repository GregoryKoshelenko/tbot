pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: golang
    image: golang:1.22-bookworm
    command:
    - cat
    tty: true
'''
        }
    }
    parameters {
        choice(
            name: 'OS',
            choices: ['linux', 'darwin', 'windows'],
            description: 'Target operating system'
        )
        choice(
            name: 'ARCH',
            choices: ['amd64', 'arm64'],
            description: 'Target architecture'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip running tests'
        )
        booleanParam(
            name: 'SKIP_LINT',
            defaultValue: false,
            description: 'Skip running linter'
        )
    }
    environment {
        TARGETOS = "${params.OS}"
        TARGETARCH = "${params.ARCH}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Lint') {
            when { expression { !params.SKIP_LINT } }
            steps {
                container('golang') {
                    sh 'make lint'
                }
            }
        }
        stage('Test') {
            when { expression { !params.SKIP_TESTS } }
            steps {
                container('golang') {
                    sh 'make test'
                }
            }
        }
        stage('Build') {
            steps {
                container('golang') {
                    script {
                        def target = ''
                        if (params.OS == 'linux' && params.ARCH == 'amd64') target = 'linux'
                        else if (params.OS == 'linux' && params.ARCH == 'arm64') target = 'arm'
                        else if (params.OS == 'darwin' && params.ARCH == 'amd64') target = 'macos'
                        else if (params.OS == 'darwin' && params.ARCH == 'arm64') target = 'macos-arm'
                        else if (params.OS == 'windows' && params.ARCH == 'amd64') target = 'windows'
                        else if (params.OS == 'windows' && params.ARCH == 'arm64') target = 'windows-arm'
                        sh "make ${target}"
                    }
                }
            }
        }
        stage('Docker Build') {
            steps {
                container('golang') {
                    sh 'make image'
                }
            }
        }
        stage('Push Image') {
            steps {
                container('golang') {
                    sh 'make push'
                }
            }
        }
    }
    post {
        always {
            container('golang') {
                sh 'rm -rf *'
            }
        }
    }
}
