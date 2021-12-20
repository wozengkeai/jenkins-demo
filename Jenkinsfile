node('jenkins-jnlp') {
    stage('Clone') {
      echo "1.Prepare Stage"
	  checkout scm
	  script {
        build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    }
    }
    stage('Test') {
      echo "2.Test Stage"
    }
    stage('Build') {
      echo "3.Build Docker Image Stage"
	  sh "docker build -t 192.168.100.51:30003/jenkins/jenkins-demo:${build_tag} ."
    }
    stage('Push') {
      echo "4.Push Docker Image Stage"
	  withCredentials([usernamePassword(credentialsId: 'dockerHarbor', passwordVariable: 'dockerHarborValue', usernameVariable: 'dockerHarborUser')]) {
	    //sh "pwd"
        sh "echo '${dockerHarborValue}' | docker login 192.168.100.51:30003 -u ${dockerHarborUser} --password-stdin "
        sh "docker push 192.168.100.51:30003/jenkins/jenkins-demo:${build_tag}"
		}
    }
    stage('YAML') {
      echo "5. Change YAML File Stage"
	  sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
      //sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
    }
    stage('Deploy') {
      echo "6. Deploy Stage"
	  sh "kubectl apply -f k8s.yaml -n jenkins-demo"
    }
}