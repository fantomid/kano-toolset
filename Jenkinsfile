#!/usr/bin/env groovy

@Library('kanolib')
import build_deb_pkg


stage ('Build') {
    // build_deb_pkg 'kano-toolset', env.BRANCH_NAME, 'scratch'
    // milestone()
}

stage('Test') {
    node ('os') {
        docker.image('kano-testing-container').inside() {
            sh 'which cross-build-start'
            sh 'cross-build-start'
            try {
                sh 'apt-get update'
                sh 'apt-get install kano-toolset'
                scm checkout
                sh 'python ./tests/test_logging.py'
                sh 'python ./tests/test_lua.py'
                sh 'python ./tests/test_rpi_models.py'
            } catch (err) {
                sh 'cross-build-end'
                throw err
            }
        }
    }
}
