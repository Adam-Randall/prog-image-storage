// Determine Branch from Github
branchName = env.JOB_NAME.split('/')[(env.JOB_NAME.split('/').length) - 1]


// Node type defined in Jenkins configuration
node('coreos') { 

  // Clean workspace
  cleanWs() 

  // Wrapper to catch build results and notify stackerholders e.g. Slack / SNS
  withNotify( 
    {

      // Clone branch of github and load enivrionments based on file
      stage('Pre') {
        checkout scm
        load(env_file_name)
      }

      stage('Test') {
        // Run tests isolated in a container
      }

      stage('Determine Enviroments') {
        // Determine environment to deploy to based on branch name
        environments = environmentsToDeployTo(branchName)
      }

      // Deploy to environments if exist
      if (environments.size() > 0) {

        // Build and push container to AWS ECS or equivalent 
        stage('Build and Push') {
          buildAndPush()
        }

        stage('Deploy to Enivorments') {

          // Deploy to each environment, if there is more than one e.g. different development environments
          environments.each { environment ->

            // Determine if manual approval is required for particular environment
            if (environment.approval == true) {
              manualApproval()
            }

            stage("Apply Secrets / Environment Variables") {
              // Apply secrets to environment, whether this is Kubenetes or equivalent
            }

            stage("Deploy") {
              // Deploy container to environment, whether this is Kubenetes or equivalent
            }
          }
        }
      }
    },
  )
}
