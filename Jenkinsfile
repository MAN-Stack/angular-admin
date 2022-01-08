pipeline {
  agent any
  parameters {
    choice(name: 'CONFIG_BRANCH', description: 'Name of config GIT branch')
  }
  options {
    copyArtifactPermission('build-docker-image')
    buildDiscarder(logRotator(numToKeepStr: '4'))
  }
  stages {
    stage('Gradle Build') {
      steps {
        sh './gradlew clean ngBuild'
      }
    }
    stage('Archive artifacts') {
      steps {
        archiveArtifacts allowEmptyArchive: true, artifacts: 'Dockerfile', followSymlinks: false, onlyIfSuccessful: true
        archiveArtifacts allowEmptyArchive: true, artifacts: 'nginx.conf', followSymlinks: false, onlyIfSuccessful: true
        archiveArtifacts allowEmptyArchive: true, artifacts: 'dist/**', followSymlinks: false, onlyIfSuccessful: true
      }
    }
    stage('Prepare docker image') {
      steps {
        build job: 'build-docker-image', parameters: [
          string(name: 'IMAGE_NAME', value: "angular-admin"),
          string(name: 'IMAGE_TAG', value: "1.0.${BUILD_ID}"),
          string(name: 'SOURCE_LOCATION', value: '/dist'),
          string(name: 'PRJ_NAME', value: "${JOB_NAME}"),
          string(name: 'PRJ_BUILD', value: "${BUILD_ID}")], wait: false
      }
    }
  }
}
