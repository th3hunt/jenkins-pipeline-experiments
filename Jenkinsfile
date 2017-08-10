String GIT_LOG;
String GIT_LOCAL_BRANCH;

def caughtError;

node(label: 'test') {
  currentBuild.result = "SUCCESS"

  ansiColor('xterm') {
    try {
      echo "A on master"

      stage('Checkout') {
        checkout([
          $class: "GitSCM",
          refspec: "+refs/heads/master:refs/remotes/origin/master +refs/heads/develop:refs/remotes/origin/develop +refs/heads/feature*:refs/remotes/origin/feature** +refs/heads/release*:refs/remotes/origin/release** +refs/tags/*:refs/remotes/origin/tags/*",
          branches: [
            [name: "*/master"],
            [name: "*/develop"],
            [name: "*/feature**"],
            [name: "*/release**"],
            [name: "*/tags/*"]
          ],
          extensions: [
            [$class: "CloneOption", honorRefspec: true, noTags: false, shallow: true,  depth: 3, timeout: 20],
            [$class: 'LocalBranch', localBranch: '**'],
            [$class: 'CleanBeforeCheckout']
          ],
          submoduleCfg: [],
          userRemoteConfigs: [
            [
              credentialsId: "pavlakis-github-token",
              url: "https://github.com/th3hunt/jenkins-pipeline-experiments"
            ]
          ]
        ])
      }

      echo "After ${env.GIT_COMMIT}"

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
