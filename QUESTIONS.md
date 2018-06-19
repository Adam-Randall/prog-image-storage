## Questions:


### What language platform did you select to implement the microservice? Why?

**Answer:**
*I chose to use the language Ruby with Grape built on top of Rack.*

*• Lightweight microservice, which doesn't require something as heavy as Ruby on Rails (too many dependencies).*

*• Very fast framework as can been seen [here](http://blog.scoutapp.com/articles/2017/02/20/rails-api-vs-sinatra-vs-grape-which-ruby-microframework-is-right-for-you) comparing fraemworks.*

*• Grape is very familiar to me and syntacally nice to develop with (as well as being nice for other developers to review).*

*• Could have used similar frameworks such as Sinatra (also a good option), however I felt I could show my experience in more detail with Grape.*

*• Previous experience with Grape microservices scaling well.*

*• Potentially could of done it in another language such as Python Flask (have had experience here too), which also runs very well.*

*• A better option would be to use API Gateway built on the back of Lambda (or alternative serverless technology), as this provides high availability and elasticity (Only experience with Lambda and have not used API Gateway, hence another reason for not using this). Downside you are tied down to use AWS and can't easily be shifted (this would come down to the client / discussion with the team).*

### How did you store the uploaded images?

**Answer:**
*I chose to store the uploaded images in AWS S3 as it provides high availability and elasticity - it is also extremely cheap and easy to host files in the Cloud. However I left the service extendable incase a different Cloud Provider is required or on prem solution.*


### What would you do differently to your implementation if you had more time?

**Answer:**
*There are several different things I could do:*

*• Extend the microservice further to handle different image transformations or create different microservices to handle different image transformations.*

*• Extend microservice to use AWS presigned urls over public_urls (better for security - no need for public_read acls).*

*• Deploy microservice containers on something like Kubernetes or similar container management system. This could be done using some sort of continuous integration tool such as Jenkins (which would also check unit tests).* 

*Once these are deployed, an application load balancer can be set up to divert traffic based on paths. E.g. /v1.0/images/upload has traffic diverted to containers on port 31010, 31011, 31012 and /v1.0/images/convert has traffic diverted to containers on port 31013, 31014, 31015*

*• Expand the microservice to handle GraphQL, which allows the consumer to decide which data they want back. e.g. Consumer may want more information other than the unique identifier*


### How would coordinate your development environment to handle the build and test process?

**Answer:**
*For my development environment I would create a pipeline (Jenkins terminology) after a commit which would run through a build cycle, from testing, deploying to container service and applying environment variables. Please see [here](https://github.com/Adam-Randall/prog-image-storage/blob/master/Jenkinsfile) for potential Jenkins pipeline. This allows testing to be done as closely as production.*


### What technologies would you use to ease the task of deploying the microservices to a production runtime environment?

**Answer:**

*• Docker for creating containers - easy to use, and standard across industry so lots of support. Also can guarantee that containers will be the same no matter where they are hosted.*

*• Jenkins for CI/CD - autonomous and can be built around most technologies, so have complete control of what your deploying*

*• Kubernetes for hosting containers - Works extremely well and can easily scale. Many setups can be done of it e.g. Self Hosted, Openshift, EKS.*


### What testing did (or would) you do, and why?

**Answer:**

*I did unit testing to test the apis, forms and service objects of the application. This covers the majority of the microservice. However I would look to expand on this to test more images to define image support types as well as load testing against the container to understand the amount of load one can take before falling over.*
