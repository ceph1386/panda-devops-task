Panda Team DevOps Test Task
===========================

Production-grade automated CI/CD pipeline and containerized web application deployment solution.

Repository Structure
--------------------
```text
├── .github/
│   └── workflows/
│       └── deploy.yml      # Automated CI/CD pipeline
├── html/
│   └── index.html          # Web application frontend
├── Dockerfile              # Optimized Alpine container definition
├── nginx.conf              # Production Nginx server config
├── docker-compose.yml      # Local orchestration manifest
└── deploy.sh               # Local deployment automation
```
Quick Start (Local Deployment)
------------------------------

To run this application locally on your machine, ensure you have Docker and Docker Compose installed, then execute:

1.  Clone the repository:
  ```bash
    git clone https://github.com/ceph1386/panda-devops-task.git
    cd panda-devops-task
  ```
    
2.  Run the deployment via Docker Compose:
   ```bash
    docker compose up -d
   ```
    
3.  Open your browser and navigate to:
    

*   http://localhost:8080
    

4.  Check the application health endpoint:
    

*   http://localhost:8080/health
    

## CI/CD Pipeline Architecture & Deployment Strategy

The automated workflow triggers on every `push` to the `main` branch and follows a strict **Build -> Push -> Staging Deploy -> Verify** lifecycle.

### 1. Architectural Approach to the "Test Server" Requirement:
To ensure 100% reproducibility without relying on a dedicated 24/7 physical VPS, the deployment phase implements an **ephemeral staging server pattern** inside isolated cloud runners:
- **Zero-Downtime Simulation:** Every commit triggers a clean container spin-up mirroring a production-like environment.
- **Automated Verification:** The pipeline acts as a self-healing gate—if the container fails to pass the internal healthcheck (`HTTP 200 OK`), the deployment fails automatically, preventing bad code from reaching the registry.

### 2. Pipeline Jobs Breakdown:
- **`build-and-push`**:
  - Checks out the source code and initializes Docker Buildx for optimized caching.
  - Authenticates securely to Docker Hub using repository secrets (`DOCKER_USERNAME`, `DOCKER_PASSWORD`).
  - Builds and pushes the multi-arch Docker image tagged with `latest` and short commit SHA to `ceph1386/panda-devops-app`.

- **`deploy-and-verify`**:
  - Pulls the freshly built image from Docker Hub to the staging environment.
  - Spins up the container and runs an automated healthcheck validation against `/health`.
  - Cleans up staging resources upon a successful pass, ensuring a clean state for subsequent runs.

**Author:** Vadym Shchuryk
