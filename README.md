Panda Team DevOps Test Task
===========================

Production-grade automated CI/CD pipeline and containerized web application deployment solution.

Repository Structure
--------------------

├── .github/│ └── workflows/│ └── deploy.yml # Automated GitHub Actions CI/CD pipeline├── html/│ └── index.html # Custom styled frontend application├── Dockerfile # Optimized Alpine Dockerfile with HEALTHCHECK├── nginx.conf # Secure production Nginx configuration├── docker-compose.yml # Local orchestration manifest└── deploy.sh # Local automation deployment script

Quick Start (Local Deployment)
------------------------------

To run this application locally on your machine, ensure you have Docker and Docker Compose installed, then execute:

1.  Clone the repository:git clone [https://github.com/ceph1386/panda-devops-task.git](https://www.google.com/url?sa=E&q=https://github.com/ceph1386/panda-devops-task.git)cd panda-devops-task
    
2.  Run the deployment via Docker Compose:docker compose up -d
    
3.  Open your browser and navigate to:
    

*   [http://localhost:8080](https://www.google.com/url?sa=E&q=http://localhost:8080)
    

1.  Check the application health endpoint:
    

*   [http://localhost:8080/health](https://www.google.com/url?sa=E&q=http://localhost:8080/health)
    

CI/CD Pipeline Architecture (GitHub Actions)
--------------------------------------------

The automated workflow triggers on every push to the main branch and consists of two sequential jobs:

1.  **build-and-push**:
    

*   Checks out the repository code.
    
*   Sets up Docker Buildx for advanced caching.
    
*   Authenticates securely to Docker Hub using repository secrets (DOCKER\_USERNAME, DOCKER\_PASSWORD).
    
*   Builds and pushes the Docker image tagged with latest and short commit SHA to ceph1386/panda-devops-app.
    

1.  **deploy-and-verify**:
    

*   Pulls the freshly built image from Docker Hub.
    
*   Spins up a staging container in an isolated runner environment.
    
*   Executes an automated healthcheck validation (HTTP 200 OK).
    
*   Automatically cleans up staging artifacts upon success.
    

**Author:** Vadym Shchuryk
