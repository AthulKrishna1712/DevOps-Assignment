node{
    stage('Clone Repo') {
            git branch: 'main', credentialsId: 'git', url: 'https://github.com/AthulKrishna1712/book-store.git'
        }
        
        stage('Maven Build') {
            def mavenHome = tool name: "MAVEN_HOME", type: "maven"
            def mavenCMD = "${mavenHome}/bin/mvn"
            sh "${mavenCMD} clean package"
        }
        
        stage('Sonarqube-Analysis') {
            withSonarQubeEnv(credentialsId: 'sonar-token') {
                sh "mvn clean verify sonar:sonar \
                -Dsonar.projectKey=demoapp-project \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.login=sqp_62fa3ac141f5060372f4be9854a6ea56d977a608"
            }
        }
        
        stage('Upload build artifact to Nexus'){
            nexusArtifactUploader artifacts: [
                [
                    artifactId: 'BookStoreManager', 
                    classifier: '', 
                    file: 'target/BookStoreManager-0.0.1-SNAPSHOT.jar', 
                    type: 'jar'
                ]
            ], 
            credentialsId: 'nexus-repo', 
            groupId: 'com.BookStore', 
            nexusUrl: '165.232.188.178:8081', 
            nexusVersion: 'nexus3', 
            protocol: 'http', 
            repository: 'Devops-assignment', 
            version: '0.0.1-SNAPSHOT'
        }
        
        stage('Build Image') {
            script{
                sh "whoami"
                sh "docker build -t athulkrishna1712/jenkinsbookstore:v1 ."
            }
        }

        
        stage('Push to DockerHub') {
            script{
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                sh "echo \${DOCKER_PASSWORD} | docker login --username \${DOCKER_USERNAME} --password-stdin"
                sh "docker push athulkrishna1712/jenkinsbookstore:v1"
                }
            }
        }
        
        stage('Deploy using Kubernetes'){
            withKubeConfig([credentialsId: 'kubernetescredential', serverUrl: 'https://BE95E460F3D53186BAEA8483248B20D9.sk1.ap-south-1.eks.amazonaws.com']) {
                    sh 'kubectl apply -f webapp.yaml'
                    sh 'kubectl apply -f service.yaml'
        }
}
