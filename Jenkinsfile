String GIT_LOG;
String GIT_LOCAL_BRANCH;

def caughtError;

node(label: 'test') {
  currentBuild.result = "SUCCESS"

  ansiColor('xterm') {
    try {
      echo "F on develop"

      stage('Checkout') {
        checkout scm
      }

      GIT_LOG = sh(returnStdout: true, script: "git log -n 1").trim()
      GIT_LOCAL_BRANCH = sh(returnStdout: true, script: "git rev-parse --abbrev-ref HEAD").trim()

      lock(resource: 'tests'){
        stage('Run Tests') {
          sleep 20
          sh "./test.sh ${params.TEST_PARAM}"
        }
      }

    } catch (err) {
      caughtError = err;
      currentBuild.result = "FAILURE"
    } finally {
      switch(currentBuild.result) {
        case "FAILURE":
          echo "${env.JOB_NAME} ${env.BUILD_NUMBER}: FAIL on *${GIT_LOCAL_BRANCH}* (<${env.BUILD_URL}|Open>)\n${GIT_LOG ? '```' + GIT_LOG + '```\n' : ''}```${caughtError}```"
          if (caughtError) {
           throw caughtError; // rethrow so that the build fails
          }
          break;
        default:
          echo "${env.JOB_NAME} ${env.BUILD_NUMBER}: PASS on *${GIT_LOCAL_BRANCH}* (<${env.BUILD_URL}|Open>)\n```${GIT_LOG}```"
      }
      if (caughtError) {
        throw caughtError; // rethrow so that the build fails
      }
    }
  }
}
