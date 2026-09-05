CI/CD Pipeline with GitHub Actions, Docker, Amazon ECR, ECS Fargate, and Terraform

Project Overview

In this project, I built a complete CI/CD pipeline for a Python Flask application. The application is developed and tested locally, containerized with Docker, version-controlled with Git and GitHub, deployed to AWS infrastructure created with Terraform, stored in Amazon ECR, run on Amazon ECS Fargate, exposed through an Application Load Balancer, and automatically rebuilt and redeployed with GitHub Actions whenever code is pushed to the main branch.

GitHub Actions authenticates securely to AWS using OIDC instead of long-lived AWS access keys.

All AWS resources are deployed in:

us-west-2

Architecture



Architecture overview: Developer → GitHub → GitHub Actions → Docker build → Amazon ECR → Amazon ECS Fargate → Application Load Balancer → Flask application. Terraform provisions and manages the AWS infrastructure.

Developer
   ↓
Git Commit & Push
   ↓
GitHub Repository
   ↓
GitHub Actions
   ↓
AWS Authentication with OIDC
   ↓
Build Docker Image
   ↓
Push Image to Amazon ECR
   ↓
Register New ECS Task Definition
   ↓
Update ECS Service
   ↓
Amazon ECS Fargate
   ↓
Application Load Balancer
   ↓
Flask Application

Terraform manages the AWS infrastructure:

Terraform
   ↓
VPC
├── Public Subnet A - us-west-2a
├── Public Subnet B - us-west-2b
├── Private Subnet A - us-west-2a
└── Private Subnet B - us-west-2b
   ↓
Internet Gateway + NAT Gateway
   ↓
Security Groups
   ↓
Application Load Balancer
   ↓
Amazon ECR
   ↓
Amazon ECS Fargate
   ↓
IAM + CloudWatch

Technologies Used

Python

Flask

Gunicorn

Docker

Git

GitHub

GitHub Actions

Terraform

AWS CLI

Amazon VPC

Amazon ECR

Amazon ECS Fargate

Application Load Balancer

AWS IAM

GitHub OIDC

Amazon CloudWatch

Project Structure

CICD-ECS-PROJECT/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── terraform/
│   ├── .terraform.lock.hcl
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
├── .dockerignore
├── .gitignore
├── Dockerfile
├── app.py
├── requirements.txt
└── README.md

Stage 1 — Create and Test the Flask Application

1. Clone the Repository

git clone https://github.com/abiyecomgit/CICD-ECS-PROJECT.git
cd CICD-ECS-PROJECT

2. Verify Python

python3 --version

3. Create a Virtual Environment

python3 -m venv .venv
source .venv/bin/activate

The terminal should show:

(.venv)

4. Install Dependencies

pip install -r requirements.txt

Verify Flask and Gunicorn:

pip show Flask
pip show gunicorn

5. Run the Flask Application

python3 app.py

Open:

http://localhost:5000

Expected page:

Hello from CI/CD Pipeline!

Test the health endpoint:

curl http://localhost:5000/health

Example response:

{
  "application": "cicd-ecs-project",
  "aws_region": "us-west-2",
  "status": "healthy"
}

Stop the Flask development server with CTRL + C.

Stage 2 — Containerize the Application with Docker

6. Verify Docker

Make sure Docker Desktop is running.

docker --version
docker info

7. Build the Docker Image

From the project root:

docker build -t cicd-ecs-app:local .

Verify the image:

docker images cicd-ecs-app

Expected image:

cicd-ecs-app:local

8. Run the Docker Container Locally

docker run -d \
  --name cicd-ecs-container \
  -p 3000:5000 \
  cicd-ecs-app:local

Port mapping:

localhost:3000 → container:5000

Verify the running container:

docker ps

Expected mapping:

0.0.0.0:3000->5000/tcp

9. Verify the Containerized Application

Open:

http://localhost:3000

Expected:

Hello from CI/CD Pipeline!

Health check:

curl http://localhost:3000/health

Check logs:

docker logs cicd-ecs-container

Verify the container is running as a non-root user:

docker exec cicd-ecs-container whoami

Expected:

appuser

10. Stop and Remove the Local Container

docker stop cicd-ecs-container
docker rm cicd-ecs-container

The Docker image remains available locally.

Stage 3 — Verify AWS CLI and Terraform

11. Verify AWS CLI

aws --version
aws configure list
aws configure get region

Expected region:

us-west-2

Verify authentication:

aws sts get-caller-identity

Do not place AWS access keys or secret keys in this repository.

12. Verify Terraform

terraform --version

Move into the Terraform directory:

cd terraform

Stage 4 — Provision AWS Infrastructure with Terraform

Terraform creates the AWS infrastructure required to run the application on ECS Fargate.

Terraform Files

File

Purpose

versions.tf

Defines Terraform and AWS provider versions.

provider.tf

Configures AWS and sets the region to us-west-2.

variables.tf

Defines reusable project variables.

networking.tf

Creates the VPC, subnets, Internet Gateway, NAT Gateway, and route tables.

security.tf

Creates ALB and ECS security groups and rules.

ecr.tf

Creates the ECR repository and lifecycle policy.

iam.tf

Creates ECS execution and task IAM roles.

logs.tf

Creates the CloudWatch log group.

alb.tf

Creates the ALB, listener, and target group.

ecs.tf

Creates the ECS cluster, task definition, and Fargate service.

github-actions.tf

Creates GitHub OIDC and the GitHub Actions IAM role.

outputs.tf

Displays useful resource information after deployment.

13. Initialize Terraform

terraform init

Expected:

Terraform has been successfully initialized!

14. Format Terraform

terraform fmt
terraform fmt -check

15. Validate Terraform

terraform validate

Expected:

Success! The configuration is valid.

16. Create the Initial Terraform Plan

Before the first application image exists in ECR, create the ECS service with zero running tasks:

terraform plan \
  -var="desired_count=0" \
  -out=tfplan

This prevents ECS from trying to start a task before an image exists in ECR.

17. Apply the Initial Infrastructure

terraform apply tfplan

Terraform creates resources including:

VPC

Two public subnets

Two private subnets

Internet Gateway

NAT Gateway

Route tables

Security groups

ECR repository

ECS cluster

ECS task definition

ECS service

Application Load Balancer

Target group

Listener

IAM roles

CloudWatch log group

18. Verify Terraform Resources

terraform state list
terraform output

Typical outputs include:

aws_region
vpc_id
ecr_repository_url
ecs_cluster_name
ecs_service_name
alb_dns_name
application_url

19. Verify Resources in AWS Console

Select Oregon (us-west-2) and verify:

VPC → Your VPCs

VPC → Subnets

VPC → Internet Gateways

VPC → NAT Gateways

VPC → Route Tables

VPC / EC2 → Security Groups

ECR → Repositories

ECS → Clusters

ECS → Task Definitions

EC2 → Load Balancers

EC2 → Target Groups

IAM → Roles

CloudWatch → Log groups

Stage 5 — Amazon ECR

The ECR repository is:

cicd-ecs-app

It is configured with:

Image scanning

AES256 encryption

Immutable image tags

Image lifecycle policy

The CI/CD workflow uses a unique Git commit SHA as the image tag so deployments are traceable.

Stage 6 — Configure GitHub OIDC Authentication

GitHub Actions authenticates to AWS using OIDC:

GitHub Actions
      ↓
GitHub OIDC Token
      ↓
AWS IAM Trust Policy
      ↓
Temporary AWS Credentials

This avoids storing long-lived credentials such as:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

20. Create the GitHub Environment

In GitHub:

Repository
→ Settings
→ Environments
→ New environment

Create:

production

The workflow uses:

environment: production

21. Configure GitHub Environment Variables

Go to:

Repository
→ Settings
→ Environments
→ production

Create these environment variables:

AWS_REGION=us-west-2
ECR_REPOSITORY=cicd-ecs-app
ECS_CLUSTER=cicd-ecs-project-cluster
ECS_SERVICE=cicd-ecs-project-service
CONTAINER_NAME=cicd-ecs-app
AWS_ROLE_ARN=<YOUR_GITHUB_ACTIONS_IAM_ROLE_ARN>

Retrieve the GitHub Actions IAM role ARN with:

terraform output -raw github_actions_role_arn

Do not commit AWS credentials, GitHub tokens, or passwords.

22. Configure the GitHub OIDC Trust Policy

The IAM role trust policy must allow:

sts:AssumeRoleWithWebIdentity

The trust policy must also match the GitHub OIDC sub claim used by the repository and the production environment.

If a customized GitHub OIDC subject template is enabled, inspect the actual OIDC claims and configure the AWS IAM trust policy to match the subject exactly.

Stage 7 — GitHub Actions CI/CD Pipeline

The workflow is stored at:

.github/workflows/deploy.yml

It triggers automatically when code is pushed to:

main

Pipeline flow:

Push to main
      ↓
Checkout repository
      ↓
Authenticate to AWS using OIDC
      ↓
Login to Amazon ECR
      ↓
Build Docker image
      ↓
Tag image with Git commit SHA
      ↓
Push image to ECR
      ↓
Download current ECS task definition
      ↓
Update Docker image
      ↓
Register new ECS task definition
      ↓
aws ecs update-service
      ↓
Wait for ECS service stability
      ↓
Deployment complete

23. GitHub Actions Workflow

name: Build and Deploy to Amazon ECS

on:
  push:
    branches:
      - main

permissions:
  contents: read
  id-token: write

jobs:
  deploy:
    name: Build and Deploy
    runs-on: ubuntu-latest
    environment: production

    env:
      AWS_REGION: ${{ vars.AWS_REGION }}
      ECR_REPOSITORY: ${{ vars.ECR_REPOSITORY }}
      ECS_CLUSTER: ${{ vars.ECS_CLUSTER }}
      ECS_SERVICE: ${{ vars.ECS_SERVICE }}
      CONTAINER_NAME: ${{ vars.CONTAINER_NAME }}

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_ROLE_ARN }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build and push Docker image
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          IMAGE_URI="$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"

          docker build \
            --platform linux/amd64 \
            -t "$IMAGE_URI" \
            .

          docker push "$IMAGE_URI"

          echo "image=$IMAGE_URI" >> "$GITHUB_OUTPUT"

      - name: Download current ECS task definition
        run: |
          TASK_DEFINITION=$(aws ecs describe-services \
            --cluster "$ECS_CLUSTER" \
            --services "$ECS_SERVICE" \
            --query "services[0].taskDefinition" \
            --output text)

          aws ecs describe-task-definition \
            --task-definition "$TASK_DEFINITION" \
            --query "taskDefinition" \
            > task-definition.json

      - name: Render Amazon ECS task definition
        id: task-def
        uses: aws-actions/amazon-ecs-render-task-definition@v1
        with:
          task-definition: task-definition.json
          container-name: ${{ env.CONTAINER_NAME }}
          image: ${{ steps.build-image.outputs.image }}

      - name: Register new ECS task definition
        id: register-task
        run: |
          TASK_DEFINITION_ARN=$(aws ecs register-task-definition \
            --cli-input-json file://${{ steps.task-def.outputs.task-definition }} \
            --query "taskDefinition.taskDefinitionArn" \
            --output text)

          echo "task_definition_arn=$TASK_DEFINITION_ARN" >> "$GITHUB_OUTPUT"

      - name: Deploy updated image to ECS
        run: |
          aws ecs update-service \
            --cluster "$ECS_CLUSTER" \
            --service "$ECS_SERVICE" \
            --task-definition "${{ steps.register-task.outputs.task_definition_arn }}" \
            --force-new-deployment

      - name: Wait for ECS deployment
        run: |
          aws ecs wait services-stable \
            --cluster "$ECS_CLUSTER" \
            --services "$ECS_SERVICE"

      - name: Deployment completed
        run: |
          echo "Deployment completed successfully."

Stage 8 — Push the Project to GitHub

Check Git:

git status

Stage files:

git add .

Commit:

git commit -m "Add CI/CD pipeline"

Push:

git push origin main

Because the workflow triggers on main, the push automatically starts GitHub Actions.

Stage 9 — Verify the CI/CD Pipeline

Go to:

GitHub
→ CICD-ECS-PROJECT
→ Actions

A successful workflow should show steps similar to:

✓ Checkout repository
✓ Configure AWS credentials
✓ Login to Amazon ECR
✓ Build and push Docker image
✓ Download current ECS task definition
✓ Render Amazon ECS task definition
✓ Register new ECS task definition
✓ Deploy updated image to ECS
✓ Wait for ECS deployment
✓ Deployment completed

24. Verify the Docker Image in ECR

Go to:

AWS Console
→ ECR
→ Repositories
→ cicd-ecs-app

A new image should appear with a unique Git commit SHA tag.

25. Verify ECS

Go to:

AWS Console
→ ECS
→ Clusters
→ cicd-ecs-project-cluster
→ Services
→ cicd-ecs-project-service

Verify:

Desired tasks: 1
Running tasks: 1

Also verify that a newer task definition revision was registered.

26. Verify the Target Group

Go to:

EC2
→ Target Groups
→ cicd-ecs-tg
→ Targets

The ECS target should show:

Healthy

The ALB health check uses:

/health

27. Verify the Application Through the ALB

From the Terraform directory:

terraform output -raw application_url

Open the returned URL in your browser.

Expected:

Hello from CI/CD Pipeline!

Also test:

http://<ALB-DNS-NAME>/health

Stage 10 — Prove Automatic Deployment Works

Modify the application text in app.py, then commit and push:

git add app.py
git commit -m "Update application homepage"
git push origin main

Do not manually run Docker build, ECR push, or ECS deployment commands.

GitHub Actions should automatically:

Detect push
   ↓
Build Docker image
   ↓
Push image to ECR
   ↓
Register new ECS task definition
   ↓
Update ECS service
   ↓
Start new Fargate task

After the workflow succeeds, refresh the ALB URL. If the new application text appears, the CI/CD pipeline has been verified end-to-end.

Security Best Practices Used

GitHub OIDC instead of permanent AWS access keys

Temporary AWS credentials for GitHub Actions

IAM trust restricted to the GitHub repository/environment

ECS Fargate tasks in private subnets

Public ALB in public subnets

ECS security group accepts application traffic only from the ALB

Non-root Docker container user

ECR image scanning

ECR encryption

Immutable Docker image tags

Unique Git SHA image tags

Terraform state excluded from Git

.env files excluded from Git

.venv excluded from Git

CloudWatch logging enabled

Infrastructure managed as code

.gitignore

# Python
__pycache__/
*.py[cod]
*.pyo

# Virtual Environment
.venv/
venv/

# Environment Variables
.env
*.env

# Python Cache
.pytest_cache/

# macOS
.DS_Store

# VS Code
.vscode/

# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json
tfplan
*.tfplan

.terraform.lock.hcl is intentionally committed so Terraform provider versions remain consistent.

Challenges and Troubleshooting

Virtual Environment Could Not Be Activated

Error:

source: no such file or directory: .venv/bin/activate

Solution:

python3 -m venv .venv
source .venv/bin/activate

Git Was Initialized in the Wrong Directory

Git initially treated the home directory as the repository.

Verified with:

git rev-parse --show-toplevel

The incorrect home-level Git repository was removed and Git was initialized inside CICD-ECS-PROJECT.

Flask app Was Not Defined

Error:

NameError: name 'app' is not defined

Solution: restore app = Flask(__name__) before the route definitions.

Terraform ECR Syntax Error

Plain English notes were accidentally added as Terraform code.

Incorrect:

Image scanning enabled
Encryption enabled

Correct:

# Image scanning enabled
# Encryption enabled

Terraform Security Group Dependency Cycle

Error:

Cycle: aws_security_group.ecs, aws_security_group.alb

Solution: create the security groups separately from the ingress and egress rule resources to remove the circular dependency.

GitHub OIDC Authentication Failure

Error:

Not authorized to perform sts:AssumeRoleWithWebIdentity

Troubleshooting included verifying the GitHub Actions IAM role ARN, confirming id-token: write, checking the production GitHub environment, inspecting the actual GitHub OIDC token claims, and updating the AWS IAM trust policy so the expected sub claim matched the claim GitHub issued.

Useful Verification Commands

Git

git status
git remote -v
git branch
git log --oneline

Docker

docker images cicd-ecs-app
docker ps
docker logs cicd-ecs-container

Terraform

terraform fmt -check
terraform validate
terraform plan
terraform state list
terraform output

AWS

aws sts get-caller-identity
aws configure list
aws configure get region

Cleanup

AWS resources such as the NAT Gateway, Application Load Balancer, and ECS Fargate tasks can generate charges.

When the project is no longer required:

cd terraform

Review the destroy plan:

terraform plan \
  -destroy \
  -var="github_repository=abiyecomgit/CICD-ECS-PROJECT" \
  -var="desired_count=0"

Destroy the infrastructure:

terraform destroy \
  -var="github_repository=abiyecomgit/CICD-ECS-PROJECT" \
  -var="desired_count=0"

Type yes when prompted.

Verify Terraform no longer tracks resources:

terraform state list

Also verify the AWS Console to confirm billable resources have been removed.

Final Result

This project demonstrates a complete DevOps CI/CD workflow:

Developer
   ↓
GitHub
   ↓
GitHub Actions
   ↓
Docker Build
   ↓
Amazon ECR
   ↓
Amazon ECS Fargate
   ↓
Application Load Balancer
   ↓
Flask Application

Terraform manages the AWS infrastructure while GitHub Actions automates application delivery. The final result is a secure, repeatable, version-controlled, and automated CI/CD pipeline running in AWS us-west-2.
