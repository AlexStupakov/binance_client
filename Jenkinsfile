pipeline {
  agent any

  stages {
    stage('Test') {
      steps {
        /* `make check` returns non-zero on test failures,
        * using `true` to allow the Pipeline to continue nonetheless
        */
        sh 'pwd',
        dir(srcDir){
          sh 'pwd',
          sh 'ls -al',
          sh 'cdr=$(pwd); $cdr/jenkins.sh'
        }
      }
    }
  }
}