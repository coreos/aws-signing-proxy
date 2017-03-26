#!/usr/bin/env groovy
node ('docker') {
    checkout scm
    def gitSha= sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    stage('build'){
        def projectPath = '/go/src/github.com/coreos/aws-signing-proxy'
        def runArgs = "-v ${env.WORKSPACE}:${projectPath} -v /etc/passwd:/etc/passwd:ro -e GOPATH=/go"
        docker.image('golang:1.8').inside(runArgs) {
            sh '''
            mkdir -p $GOPATH/bin
            mkdir -p $GOPATH/pkg
            cd $GOPATH/src/github.com/coreos/aws-signing-proxy

            curl https://glide.sh/get | sh
            glide --no-color install --strip-vendor
            CGO_ENABLED=0
            GOOS=linux
            go build \
                -ldflags "-linkmode external -extldflags -static" \
                -o aws-signing-proxy \
                github.com/coreos/aws-signing-proxy
            '''
        }
    }
    stage('push') {
        docker.withRegistry('https://quay.io/v1/', 'tectonic-quay-robot') {
            def app = docker.build "quay.io/coreos/aws-signing-proxy:${gitSha}"
            app.push()
            app.push 'latest'
        }
    }
}
