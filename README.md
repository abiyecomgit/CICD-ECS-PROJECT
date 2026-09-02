# CI/CD Pipeline with GitHub Actions, Docker, Amazon ECS Fargate & Terraform

## Project Overview

This project demonstrates how to build an end-to-end CI/CD pipeline for a Python Flask application using GitHub Actions, Docker, Amazon ECR, Amazon ECS Fargate, and Terraform.

The application is containerized with Docker, infrastructure is provisioned with Terraform, and deployments are fully automated through GitHub Actions.

---

# Architecture

```text
Developer
      │
      ▼
GitHub Repository
      │
      ▼
GitHub Actions
      │
      ▼
Build Docker Image
      │
      ▼
Amazon ECR
      │
      ▼
Amazon ECS Fargate
      │
      ▼
Application Load Balancer
      │
      ▼
Flask Application
```

---

# Technologies Used

- Python
- Flask
- Docker
- Terraform
- Git
- GitHub
- GitHub Actions
- AWS CLI
- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancer
- IAM (OIDC Authentication)
- CloudWatch

---

# Project Structure

```text
CICD-ECS-PROJECT/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── terraform/
│   ├── alb.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── github-actions.tf
│   ├── iam.tf
│   ├── logs.tf
│   ├── networking.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── security.tf
│   ├── variables.tf
│   └── versions.tf
│
├── Dockerfile
├── app.py
├── requirements.txt
├── .dockerignore
├── .gitignore
└── README.md
```

---

# Prerequisites

Before running this project, install:

- Python 3
- Docker Desktop
- Terraform
- AWS CLI
- Git
- VS Code (recommended)

---

# Step 1 – Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd CICD-ECS-PROJECT
```

---

# Step 2 – Create a Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

---

# Step 3 – Install Dependencies

```bash
pip install -r requirements.txt
```

---

# Step 4 – Run the Flask Application

```bash
python3 app.py
```

Open your browser:

```
http://localhost:5000
```

---

# Step 5 – Build the Docker Image

```bash
docker build -t cicd-ecs-app:local .
```

Verify the image:

```bash
docker images
```

---

# Step 6 – Run the Docker Container

```bash
docker run -d \
--name cicd-ecs-container \
-p 3000:5000 \
cicd-ecs-app:local
```

Open:

```
http://localhost:3000
```

---

# Step 7 – Deploy AWS Infrastructure

Move to the Terraform folder:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Format the files:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Type:

```
yes
```

when prompted.

---

# Step 8 – Configure GitHub Actions

Create a GitHub Environment named:

```
production
```

Add the following Environment Variables:

- AWS_REGION
- AWS_ROLE_ARN
- ECR_REPOSITORY
- ECS_CLUSTER
- ECS_SERVICE
- CONTAINER_NAME

---

# Step 9 – Trigger the CI/CD Pipeline

Commit and push your changes:

```bash
git add .
git commit -m "Deploy application"
git push origin main
```

GitHub Actions will automatically:

- Build the Docker image
- Push the image to Amazon ECR
- Register a new ECS Task Definition
- Deploy the application to Amazon ECS

---

# Verification

Confirm the following:

- ✅ Flask application runs locally
- ✅ Docker image builds successfully
- ✅ Docker container runs locally
- ✅ Amazon ECR contains the Docker image
- ✅ ECS Cluster has a running task
- ✅ Target Group status is **Healthy**
- ✅ Application is accessible through the Load Balancer
- ✅ GitHub Actions workflow completes successfully

---

# Challenges Faced

- Terraform validation errors.
- GitHub Actions authentication issues.
- ECS service returned a **503 Service Temporarily Unavailable** error.
- Incorrect IAM role references.
- Infrastructure configuration drift.

---

# Solutions Implemented

- Corrected Terraform configuration and variables.
- Configured GitHub OIDC authentication correctly.
- Fixed ECS desired task count.
- Corrected IAM role references.
- Restored Terraform networking configuration.
- Verified deployment using ECS, ECR, ALB, and GitHub Actions.

---

# What I Learned

Through this project, I learned how to:

- Build a containerized application with Docker.
- Provision AWS infrastructure using Terraform.
- Store Docker images in Amazon ECR.
- Deploy applications on Amazon ECS Fargate.
- Automate deployments using GitHub Actions.
- Secure AWS authentication with GitHub OIDC.
- Troubleshoot real-world CI/CD deployment issues.

---

# Cleanup

Destroy all AWS resources:

```bash
cd terraform

terraform destroy
```

Type:

```
yes
```

when prompted.

---

# Key Features

- Infrastructure as Code with Terraform
- Containerized application using Docker
- Automated CI/CD with GitHub Actions
- Secure authentication using AWS OIDC
- Container registry with Amazon ECR
- Serverless container deployment with Amazon ECS Fargate
- Application Load Balancer
- CloudWatch logging
- Version-controlled with Git and GitHub

---

## Author

**Abraham Iyere**

AWS | DevOps | Cloud Engineer

GitHub: https://github.com/abiyecomgit

LinkedIn: *(Add your LinkedIn profile here)*

---
