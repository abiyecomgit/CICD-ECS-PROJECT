
qqq(1).png
why is that pop up on my vs code?

d50af486-bf6d-4bdd-839f-94a919fd0f3e.png
confirm if terraform was created correctly and in the right place

wwwww(1).png
why are some of the tf file on the open editiors?


Pasted text(8).txt
Document

git.png
here is my created repo

gttttt.png
here is a screenshut of my github, give me the full link to create the plan

hhh(1).png

tttt.png
This is result

iiiii.png
the result

This simply means the VS Code command-line tool (code) hasn't been added to your PATH yet. Your README file is already created, so you can still edit it.

Option 1 (Easiest)
Open VS Code normally.

Open Visual Studio Code.

Click File → Open Folder.

Open:

/Users/greatness/CICD-ECS-PROJECT
In the Explorer, click README.md.

Paste the README content and save (⌘ + S).

Option 2 (Enable the code command)
If you'd like to open files from the terminal in the future:

Open VS Code.

Press ⌘ + Shift + P.

Type:

Shell Command: Install 'code' command in PATH
Select it and press Enter.

After that, restart your terminal and you'll be able to use:

code README.md
or

code .
to open the entire project.

After saving the README
Run:

git status
Then we'll stage the README and review the Terraform changes before committing.


Give me the readme.me file 

Absolutely. Since your README is quite long, it's better to provide it as a downloadable file rather than trying to fit it all into a single chat response.

I can generate a professional README.md that includes:

✅ Project overview

✅ Architecture diagram

✅ Technologies used

✅ Step-by-step setup instructions

✅ Local Flask setup

✅ Docker build and verification

✅ Terraform provisioning

✅ AWS infrastructure explanation

✅ GitHub Actions CI/CD pipeline

✅ Amazon ECR

✅ Amazon ECS Fargate

✅ Application Load Balancer

✅ GitHub OIDC authentication

✅ Verification steps

✅ Challenges and troubleshooting

✅ Security best practices

✅ Cleanup instructions

✅ Project summary

It will be formatted exactly like a professional GitHub project README, ready to commit as:

README.md
This will be suitable for your GitHub repository and portfolio.


I want a README with full step-by-step instructions for this project

I created the full README.md for your project with the complete step-by-step workflow, including Flask, Docker, Terraform, AWS ECR, ECS Fargate, ALB, GitHub Actions, OIDC, verification, troubleshooting, security best practices, and cleanup.

README.md

After you save it into your project root as:

CICD-ECS-PROJECT/README.md
run:

git add README.md
git commit -m "Add complete project README"
git push origin main
Because your pipeline triggers on pushes to main, this README commit may also trigger GitHub Actions. 


Library
/
README.md


# CI/CD Pipeline with GitHub Actions, Docker, Amazon ECR, ECS Fargate, and Terraform

## Project Overview

In this project, I built a complete CI/CD pipeline for a Python Flask application. The application is developed and tested locally, containerized with Docker, version-controlled with Git and GitHub, deployed to AWS infrastructure created with Terraform, stored in Amazon ECR, run on Amazon ECS Fargate, exposed through an Application Load Balancer, and automatically rebuilt and redeployed with GitHub Actions whenever code is pushed to the `main` branch.

GitHub Actions authenticates securely to AWS using OIDC instead of long-lived AWS access keys.

All AWS resources are deployed in:

```text
us-west-2
```

## Architecture

```text
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
```

Terraform manages the AWS infrastructure:

```text
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
```

## Technologies Used

- Python
- Flask
- Gunicorn
- Docker
- Git
- GitHub
- GitHub Actions
- Terraform
- AWS CLI
- Amazon VPC
- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancer
- AWS IAM
- GitHub OIDC
- Amazon CloudWatch

## Project Structure

```text
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
```

# Stage 1 — Create and Test the Flask Application

## 1. Clone the Repository

```bash
git clone https://github.com/abiyecomgit/CICD-ECS-PROJECT.git
cd CICD-ECS-PROJECT
```

## 2. Verify Python

```bash
python3 --version
```

## 3. Create a Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

The terminal should show:

```text
(.venv)
```

## 4. Install Dependencies

```bash
pip install -r requirements.txt
```

Verify Flask and Gunicorn:

```bash
pip show Flask
pip show gunicorn
```

## 5. Run the Flask Application

```bash
python3 app.py
```

Open:

```text
http://localhost:5000
```

Expected page:

```text
Hello from CI/CD Pipeline!
```

Test the health endpoint:

```bash
curl http://localhost:5000/health
```

Example response:

```json
{
  "application": "cicd-ecs-project",
  "aws_region": "us-west-2",
  "status": "healthy"
}
```

Stop the Flask development server with `CTRL + C`.

# Stage 2 — Containerize the Application with Docker

## 6. Verify Docker

Make sure Docker Desktop is running.

```bash
docker --version
docker info
```

## 7. Build the Docker Image

From the project root:

```bash
docker build -t cicd-ecs-app:local .
```

Verify the image:

```bash
docker images cicd-ecs-app
```

Expected image:

```text
cicd-ecs-app:local
```

## 8. Run the Docker Container Locally

```bash
docker run -d \
  --name cicd-ecs-container \
  -p 3000:5000 \
  cicd-ecs-app:local
```

Port mapping:

```text
localhost:3000 → container:5000
```

Verify the running container:

```bash
docker ps
```

Expected mapping:

```text
0.0.0.0:3000->5000/tcp
```

## 9. Verify the Containerized Application

Open:

```text
http://localhost:3000
```

Expected:

```text
Hello from CI/CD Pipeline!
```

Health check:

```bash
curl http://localhost:3000/health
```

Check logs:

```bash
docker logs cicd-ecs-container
```

Verify the container is running as a non-root user:

```bash
docker exec cicd-ecs-container whoami
```

Expected:

```text
appuser
```

## 10. Stop and Remove the Local Container

```bash
docker stop cicd-ecs-container
docker rm cicd-ecs-container
```

The Docker image remains available locally.

# Stage 3 — Verify AWS CLI and Terraform

## 11. Verify AWS CLI

```bash
aws --version
aws configure list
aws configure get region
```

Expected region:

```text
us-west-2
```

Verify authentication:

```bash
aws sts get-caller-identity
```

Do not place AWS access keys or secret keys in this repository.

## 12. Verify Terraform

```bash
terraform --version
```

Move into the Terraform directory:

```bash
cd terraform
```

# Stage 4 — Provision AWS Infrastructure with Terraform

Terraform creates the AWS infrastructure required to run the application on ECS Fargate.

## Terraform Files

| File | Purpose |
|---|---|
| `versions.tf` | Defines Terraform and AWS provider versions. |
| `provider.tf` | Configures AWS and sets the region to `us-west-2`. |
| `variables.tf` | Defines reusable project variables. |
| `networking.tf` | Creates the VPC, subnets, Internet Gateway, NAT Gateway, and route tables. |
| `security.tf` | Creates ALB and ECS security groups and rules. |
| `ecr.tf` | Creates the ECR repository and lifecycle policy. |
| `iam.tf` | Creates ECS execution and task IAM roles. |
| `logs.tf` | Creates the CloudWatch log group. |
| `alb.tf` | Creates the ALB, listener, and target group. |
| `ecs.tf` | Creates the ECS cluster, task definition, and Fargate service. |
| `github-actions.tf` | Creates GitHub OIDC and the GitHub Actions IAM role. |
| `outputs.tf` | Displays useful resource information after deployment. |

## 13. Initialize Terraform

```bash
terraform init
```

Expected:

```text
Terraform has been successfully initialized!
```

## 14. Format Terraform

```bash
terraform fmt
terraform fmt -check
```

## 15. Validate Terraform

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

## 16. Create the Initial Terraform Plan

Before the first application image exists in ECR, create the ECS service with zero running tasks:

```bash
terraform plan \
  -var="desired_count=0" \
  -out=tfplan
```

This prevents ECS from trying to start a task before an image exists in ECR.

## 17. Apply the Initial Infrastructure

```bash
terraform apply tfplan
```

Terraform creates resources including:

- VPC
- Two public subnets
- Two private subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Security groups
- ECR repository
- ECS cluster
- ECS task definition
- ECS service
- Application Load Balancer
- Target group
- Listener
- IAM roles
- CloudWatch log group

## 18. Verify Terraform Resources

```bash
terraform state list
terraform output
```

Typical outputs include:

```text
aws_region
vpc_id
ecr_repository_url
ecs_cluster_name
ecs_service_name
alb_dns_name
application_url
```

## 19. Verify Resources in AWS Console

Select `Oregon (us-west-2)` and verify:

- VPC → Your VPCs
- VPC → Subnets
- VPC → Internet Gateways
- VPC → NAT Gateways
- VPC → Route Tables
- VPC / EC2 → Security Groups
- ECR → Repositories
- ECS → Clusters
- ECS → Task Definitions
- EC2 → Load Balancers
- EC2 → Target Groups
- IAM → Roles
- CloudWatch → Log groups

# Stage 5 — Amazon ECR

The ECR repository is:

```text
cicd-ecs-app
```

It is configured with:

- Image scanning
- AES256 encryption
- Immutable image tags
- Image lifecycle policy

The CI/CD workflow uses a unique Git commit SHA as the image tag so deployments are traceable.

# Stage 6 — Configure GitHub OIDC Authentication

GitHub Actions authenticates to AWS using OIDC:

```text
GitHub Actions
      ↓
GitHub OIDC Token
      ↓
AWS IAM Trust Policy
      ↓
Temporary AWS Credentials
```

This avoids storing long-lived credentials such as:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

## 20. Create the GitHub Environment

In GitHub:

```text
Repository
→ Settings
→ Environments
→ New environment
```

Create:

```text
production
```

The workflow uses:

```yaml
environment: production
```

## 21. Configure GitHub Environment Variables

Go to:

```text
Repository
→ Settings
→ Environments
→ production
```

Create these environment variables:

```text
AWS_REGION=us-west-2
ECR_REPOSITORY=cicd-ecs-app
ECS_CLUSTER=cicd-ecs-project-cluster
ECS_SERVICE=cicd-ecs-project-service
CONTAINER_NAME=cicd-ecs-app
AWS_ROLE_ARN=<YOUR_GITHUB_ACTIONS_IAM_ROLE_ARN>
```

Retrieve the GitHub Actions IAM role ARN with:

```bash
terraform output -raw github_actions_role_arn
```

Do not commit AWS credentials, GitHub tokens, or passwords.

## 22. Configure the GitHub OIDC Trust Policy

The IAM role trust policy must allow:

```text
sts:AssumeRoleWithWebIdentity
```

The trust policy must also match the GitHub OIDC `sub` claim used by the repository and the `production` environment.

If a customized GitHub OIDC subject template is enabled, inspect the actual OIDC claims and configure the AWS IAM trust policy to match the subject exactly.

# Stage 7 — GitHub Actions CI/CD Pipeline

The workflow is stored at:

```text
.github/workflows/deploy.yml
```

It triggers automatically when code is pushed to:

```text
main
```

Pipeline flow:

```text
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
```

## 23. GitHub Actions Workflow

```yaml
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
```

# Stage 8 — Push the Project to GitHub

Check Git:

```bash
git status
```

Stage files:

```bash
git add .
```

Commit:

```bash
git commit -m "Add CI/CD pipeline"
```

Push:

```bash
git push origin main
```

Because the workflow triggers on `main`, the push automatically starts GitHub Actions.

# Stage 9 — Verify the CI/CD Pipeline

Go to:

```text
GitHub
→ CICD-ECS-PROJECT
→ Actions
```

A successful workflow should show steps similar to:

```text
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
```

## 24. Verify the Docker Image in ECR

Go to:

```text
AWS Console
→ ECR
→ Repositories
→ cicd-ecs-app
```

A new image should appear with a unique Git commit SHA tag.

## 25. Verify ECS

Go to:

```text
AWS Console
→ ECS
→ Clusters
→ cicd-ecs-project-cluster
→ Services
→ cicd-ecs-project-service
```

Verify:

```text
Desired tasks: 1
Running tasks: 1
```

Also verify that a newer task definition revision was registered.

## 26. Verify the Target Group

Go to:

```text
EC2
→ Target Groups
→ cicd-ecs-tg
→ Targets
```

The ECS target should show:

```text
Healthy
```

The ALB health check uses:

```text
/health
```

## 27. Verify the Application Through the ALB

From the Terraform directory:

```bash
terraform output -raw application_url
```

Open the returned URL in your browser.

Expected:

```text
Hello from CI/CD Pipeline!
```

Also test:

```text
http://<ALB-DNS-NAME>/health
```

# Stage 10 — Prove Automatic Deployment Works

Modify the application text in `app.py`, then commit and push:

```bash
git add app.py
git commit -m "Update application homepage"
git push origin main
```

Do not manually run Docker build, ECR push, or ECS deployment commands.

GitHub Actions should automatically:

```text
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
```

After the workflow succeeds, refresh the ALB URL. If the new application text appears, the CI/CD pipeline has been verified end-to-end.

# Security Best Practices Used

- GitHub OIDC instead of permanent AWS access keys
- Temporary AWS credentials for GitHub Actions
- IAM trust restricted to the GitHub repository/environment
- ECS Fargate tasks in private subnets
- Public ALB in public subnets
- ECS security group accepts application traffic only from the ALB
- Non-root Docker container user
- ECR image scanning
- ECR encryption
- Immutable Docker image tags
- Unique Git SHA image tags
- Terraform state excluded from Git
- `.env` files excluded from Git
- `.venv` excluded from Git
- CloudWatch logging enabled
- Infrastructure managed as code

# `.gitignore`

```gitignore
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
```

`.terraform.lock.hcl` is intentionally committed so Terraform provider versions remain consistent.

# Challenges and Troubleshooting

## Virtual Environment Could Not Be Activated

Error:

```text
source: no such file or directory: .venv/bin/activate
```

Solution:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

## Git Was Initialized in the Wrong Directory

Git initially treated the home directory as the repository.

Verified with:

```bash
git rev-parse --show-toplevel
```

The incorrect home-level Git repository was removed and Git was initialized inside `CICD-ECS-PROJECT`.

## Flask `app` Was Not Defined

Error:

```text
NameError: name 'app' is not defined
```

Solution: restore `app = Flask(__name__)` before the route definitions.

## Terraform ECR Syntax Error

Plain English notes were accidentally added as Terraform code.

Incorrect:

```text
Image scanning enabled
Encryption enabled
```

Correct:

```hcl
# Image scanning enabled
# Encryption enabled
```

## Terraform Security Group Dependency Cycle

Error:

```text
Cycle: aws_security_group.ecs, aws_security_group.alb
```

Solution: create the security groups separately from the ingress and egress rule resources to remove the circular dependency.

## GitHub OIDC Authentication Failure

Error:

```text
Not authorized to perform sts:AssumeRoleWithWebIdentity
```

Troubleshooting included verifying the GitHub Actions IAM role ARN, confirming `id-token: write`, checking the `production` GitHub environment, inspecting the actual GitHub OIDC token claims, and updating the AWS IAM trust policy so the expected `sub` claim matched the claim GitHub issued.

# Useful Verification Commands

## Git

```bash
git status
git remote -v
git branch
git log --oneline
```

## Docker

```bash
docker images cicd-ecs-app
docker ps
docker logs cicd-ecs-container
```

## Terraform

```bash
terraform fmt -check
terraform validate
terraform plan
terraform state list
terraform output
```

## AWS

```bash
aws sts get-caller-identity
aws configure list
aws configure get region
```

# Cleanup

AWS resources such as the NAT Gateway, Application Load Balancer, and ECS Fargate tasks can generate charges.

When the project is no longer required:

```bash
cd terraform
```

Review the destroy plan:

```bash
terraform plan \
  -destroy \
  -var="github_repository=abiyecomgit/CICD-ECS-PROJECT" \
  -var="desired_count=0"
```

Destroy the infrastructure:

```bash
terraform destroy \
  -var="github_repository=abiyecomgit/CICD-ECS-PROJECT" \
  -var="desired_count=0"
```

Type `yes` when prompted.

Verify Terraform no longer tracks resources:

```bash
terraform state list
```

Also verify the AWS Console to confirm billable resources have been removed.

# Final Result

This project demonstrates a complete DevOps CI/CD workflow:

```text
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
```

Terraform manages the AWS infrastructure while GitHub Actions automates application delivery. The final result is a secure, repeatable, version-controlled, and automated CI/CD pipeline running in AWS `us-west-2`.
Library
/
README.md


# CI/CD Pipeline with GitHub Actions, Docker, Amazon ECR, ECS Fargate, and Terraform

## Project Overview

In this project, I built a complete CI/CD pipeline for a Python Flask application. The application is developed and tested locally, containerized with Docker, version-controlled with Git and GitHub, deployed to AWS infrastructure created with Terraform, stored in Amazon ECR, run on Amazon ECS Fargate, exposed through an Application Load Balancer, and automatically rebuilt and redeployed with GitHub Actions whenever code is pushed to the `main` branch.

GitHub Actions authenticates securely to AWS using OIDC instead of long-lived AWS access keys.

All AWS resources are deployed in:

```text
us-west-2
```

## Architecture

```text
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
```

Terraform manages the AWS infrastructure:

```text
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
```

## Technologies Used

- Python
- Flask
- Gunicorn
- Docker
- Git
- GitHub
- GitHub Actions
- Terraform
- AWS CLI
- Amazon VPC
- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancer
- AWS IAM
- GitHub OIDC
- Amazon CloudWatch

## Project Structure

```text
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
```

# Stage 1 — Create and Test the Flask Application

## 1. Clone the Repository

```bash
git clone https://github.com/abiyecomgit/CICD-ECS-PROJECT.git
cd CICD-ECS-PROJECT
```

## 2. Verify Python

```bash
python3 --version
```

## 3. Create a Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

The terminal should show:

```text
(.venv)
```

## 4. Install Dependencies

```bash
pip install -r requirements.txt
```

Verify Flask and Gunicorn:

```bash
pip show Flask
pip show gunicorn
```

## 5. Run the Flask Application

```bash
python3 app.py
```

Open:

```text
http://localhost:5000
```

Expected page:

```text
Hello from CI/CD Pipeline!
```

Test the health endpoint:

```bash
curl http://localhost:5000/health
```

Example response:

```json
{
  "application": "cicd-ecs-project",
  "aws_region": "us-west-2",
  "status": "healthy"
}
```

Stop the Flask development server with `CTRL + C`.

# Stage 2 — Containerize the Application with Docker

## 6. Verify Docker

Make sure Docker Desktop is running.

```bash
docker --version
docker info
```

## 7. Build the Docker Image

From the project root:

```bash
docker build -t cicd-ecs-app:local .
```

Verify the image:

```bash
docker images cicd-ecs-app
```

Expected image:

```text
cicd-ecs-app:local
```

## 8. Run the Docker Container Locally

```bash
docker run -d \
  --name cicd-ecs-container \
  -p 3000:5000 \
  cicd-ecs-app:local
```

Port mapping:

```text
localhost:3000 → container:5000
```

Verify the running container:

```bash
docker ps
```

Expected mapping:

```text
0.0.0.0:3000->5000/tcp
```

## 9. Verify the Containerized Application

Open:

```text
http://localhost:3000
```

Expected:

```text
Hello from CI/CD Pipeline!
```

Health check:

```bash
curl http://localhost:3000/health
```

Check logs:

```bash
docker logs cicd-ecs-container
```

Verify the container is running as a non-root user:

```bash
docker exec cicd-ecs-container whoami
```

Expected:

```text
appuser
```

## 10. Stop and Remove the Local Container

```bash
docker stop cicd-ecs-container
docker rm cicd-ecs-container
```

The Docker image remains available locally.

# Stage 3 — Verify AWS CLI and Terraform

## 11. Verify AWS CLI

```bash
aws --version
aws configure list
aws configure get region
```

Expected region:

```text
us-west-2
```

Verify authentication:

```bash
aws sts get-caller-identity
```

Do not place AWS access keys or secret keys in this repository.

## 12. Verify Terraform

```bash
terraform --version
```

Move into the Terraform directory:

```bash
cd terraform
```

# Stage 4 — Provision AWS Infrastructure with Terraform

Terraform creates the AWS infrastructure required to run the application on ECS Fargate.

## Terraform Files

| File | Purpose |
|---|---|
| `versions.tf` | Defines Terraform and AWS provider versions. |
| `provider.tf` | Configures AWS and sets the region to `us-west-2`. |
| `variables.tf` | Defines reusable project variables. |
| `networking.tf` | Creates the VPC, subnets, Internet Gateway, NAT Gateway, and route tables. |
| `security.tf` | Creates ALB and ECS security groups and rules. |
| `ecr.tf` | Creates the ECR repository and lifecycle policy. |
| `iam.tf` | Creates ECS execution and task IAM roles. |
| `logs.tf` | Creates the CloudWatch log group. |
| `alb.tf` | Creates the ALB, listener, and target group. |
| `ecs.tf` | Creates the ECS cluster, task definition, and Fargate service. |
| `github-actions.tf` | Creates GitHub OIDC and the GitHub Actions IAM role. |
| `outputs.tf` | Displays useful resource information after deployment. |

## 13. Initialize Terraform

```bash
terraform init
```

Expected:

```text
Terraform has been successfully initialized!
```

## 14. Format Terraform

```bash
terraform fmt
terraform fmt -check
```

## 15. Validate Terraform

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

## 16. Create the Initial Terraform Plan

Before the first application image exists in ECR, create the ECS service with zero running tasks:

```bash
terraform plan \
  -var="desired_count=0" \
  -out=tfplan
```

This prevents ECS from trying to start a task before an image exists in ECR.

## 17. Apply the Initial Infrastructure

```bash
terraform apply tfplan
```

Terraform creates resources including:

- VPC
- Two public subnets
- Two private subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Security groups
- ECR repository
- ECS cluster
- ECS task definition
- ECS service
- Application Load Balancer
- Target group
- Listener
- IAM roles
- CloudWatch log group

## 18. Verify Terraform Resources

```bash
terraform state list
terraform output
```

Typical outputs include:

```text
aws_region
vpc_id
ecr_repository_url
ecs_cluster_name
ecs_service_name
alb_dns_name
application_url
```

## 19. Verify Resources in AWS Console

Select `Oregon (us-west-2)` and verify:

- VPC → Your VPCs
- VPC → Subnets
- VPC → Internet Gateways
- VPC → NAT Gateways
- VPC → Route Tables
- VPC / EC2 → Security Groups
- ECR → Repositories
- ECS → Clusters
- ECS → Task Definitions
- EC2 → Load Balancers
- EC2 → Target Groups
- IAM → Roles
- CloudWatch → Log groups

# Stage 5 — Amazon ECR

The ECR repository is:

```text
cicd-ecs-app
```

It is configured with:

- Image scanning
- AES256 encryption
- Immutable image tags
- Image lifecycle policy

The CI/CD workflow uses a unique Git commit SHA as the image tag so deployments are traceable.

# Stage 6 — Configure GitHub OIDC Authentication

GitHub Actions authenticates to AWS using OIDC:

```text
GitHub Actions
      ↓
GitHub OIDC Token
      ↓
AWS IAM Trust Policy
      ↓
Temporary AWS Credentials
```

This avoids storing long-lived credentials such as:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

## 20. Create the GitHub Environment

In GitHub:

```text
Repository
→ Settings
→ Environments
→ New environment
```

Create:

```text
production
```

The workflow uses:

```yaml
environment: production
```

## 21. Configure GitHub Environment Variables

Go to:

```text
Repository
→ Settings
→ Environments
→ production
```

Create these environment variables:

```text
AWS_REGION=us-west-2
ECR_REPOSITORY=cicd-ecs-app
ECS_CLUSTER=cicd-ecs-project-cluster
ECS_SERVICE=cicd-ecs-project-service
CONTAINER_NAME=cicd-ecs-app
AWS_ROLE_ARN=<YOUR_GITHUB_ACTIONS_IAM_ROLE_ARN>
```

Retrieve the GitHub Actions IAM role ARN with:

```bash
terraform output -raw github_actions_role_arn
```

Do not commit AWS credentials, GitHub tokens, or passwords.

## 22. Configure the GitHub OIDC Trust Policy

The IAM role trust policy must allow:

```text
sts:AssumeRoleWithWebIdentity
```

The trust policy must also match the GitHub OIDC `sub` claim used by the repository and the `production` environment.

If a customized GitHub OIDC subject template is enabled, inspect the actual OIDC claims and configure the AWS IAM trust policy to match the subject exactly.

# Stage 7 — GitHub Actions CI/CD Pipeline

The workflow is stored at:

```text
.github/workflows/deploy.yml
```

It triggers automatically when code is pushed to:

```text
main
```

Pipeline flow:

```text
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
```

## 23. GitHub Actions Workflow

```yaml
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
```

# Stage 8 — Push the Project to GitHub

Check Git:

```bash
git status
```

Stage files:

```bash
git add .
```

Commit:

```bash
git commit -m "Add CI/CD pipeline"
```

Push:

```bash
git push origin main
```

Because the workflow triggers on `main`, the push automatically starts GitHub Actions.

# Stage 9 — Verify the CI/CD Pipeline

Go to:

```text
GitHub
→ CICD-ECS-PROJECT
→ Actions
```

A successful workflow should show steps similar to:

```text
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
```

## 24. Verify the Docker Image in ECR

Go to:

```text
AWS Console
→ ECR
→ Repositories
→ cicd-ecs-app
```

A new image should appear with a unique Git commit SHA tag.

## 25. Verify ECS

Go to:

```text
AWS Console
→ ECS
→ Clusters
→ cicd-ecs-project-cluster
→ Services
→ cicd-ecs-project-service
```

Verify:

```text
Desired tasks: 1
Running tasks: 1
```

Also verify that a newer task definition revision was registered.

## 26. Verify the Target Group

Go to:

```text
EC2
→ Target Groups
→ cicd-ecs-tg
→ Targets
```

The ECS target should show:

```text
Healthy
```

The ALB health check uses:

```text
/health
```

## 27. Verify the Application Through the ALB

From the Terraform directory:

```bash
terraform output -raw application_url
```

Open the returned URL in your browser.

Expected:

```text
Hello from CI/CD Pipeline!
```

Also test:

```text
http://<ALB-DNS-NAME>/health
```

# Stage 10 — Prove Automatic Deployment Works

Modify the application text in `app.py`, then commit and push:

```bash
git add app.py
git commit -m "Update application homepage"
git push origin main
```

Do not manually run Docker build, ECR push, or ECS deployment commands.

GitHub Actions should automatically:

```text
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
```

After the workflow succeeds, refresh the ALB URL. If the new application text appears, the CI/CD pipeline has been verified end-to-end.

# Security Best Practices Used

- GitHub OIDC instead of permanent AWS access keys
- Temporary AWS credentials for GitHub Actions
- IAM trust restricted to the GitHub repository/environment
- ECS Fargate tasks in private subnets
- Public ALB in public subnets
- ECS security group accepts application traffic only from the ALB
- Non-root Docker container user
- ECR image scanning
- ECR encryption
- Immutable Docker image tags
- Unique Git SHA image tags
- Terraform state excluded from Git
- `.env` files excluded from Git
- `.venv` excluded from Git
- CloudWatch logging enabled
- Infrastructure managed as code

# `.gitignore`

```gitignore
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
```

`.terraform.lock.hcl` is intentionally committed so Terraform provider versions remain consistent.

# Challenges and Troubleshooting

## Virtual Environment Could Not Be Activated

Error:

```text
source: no such file or directory: .venv/bin/activate
```

Solution:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

## Git Was Initialized in the Wrong Directory

Git initially treated the home directory as the repository.

Verified with:

```bash
git rev-parse --show-toplevel
```

The incorrect home-level Git repository was removed and Git was initialized inside `CICD-ECS-PROJECT`.

## Flask `app` Was Not Defined

Error:

```text
NameError: name 'app' is not defined
```

Solution: restore `app = Flask(__name__)` before the route definitions.

## Terraform ECR Syntax Error

Plain English notes were accidentally added as Terraform code.

Incorrect:

```text
Image scanning enabled
Encryption enabled
```

Correct:

```hcl
# Image scanning enabled
# Encryption enabled
```

## Terraform Security Group Dependency Cycle

Error:

```text
Cycle: aws_security_group.ecs, aws_security_group.alb
```

Solution: create the security groups separately from the ingress and egress rule resources to remove the circular dependency.

## GitHub OIDC Authentication Failure

Error:

```text
Not authorized to perform sts:AssumeRoleWithWebIdentity
```

Troubleshooting included verifying the GitHub Actions IAM role ARN, confirming `id-token: write`, checking the `production` GitHub environment, inspecting the actual GitHub OIDC token claims, and updating the AWS IAM trust policy so the expected `sub` claim matched the claim GitHub issued.

# Useful Verification Commands

## Git

```bash
git status
git remote -v
git branch
git log --oneline
```

## Docker

```bash
docker images cicd-ecs-app
docker ps
docker logs cicd-ecs-container
```

## Terraform

```bash
terraform fmt -check
terraform validate
terraform plan
terraform state list
terraform output
```

## AWS

```bash
aws sts get-caller-identity
aws configure list
aws configure get region
```

# Cleanup

AWS resources such as the NAT Gateway, Application Load Balancer, and ECS Fargate tasks can generate charges.

When the project is no longer required:

```bash
cd terraform
```

Review the destroy plan:

```bash
terraform plan \
  -destroy \
  -var="github_repository=abiyecomgit/CICD-ECS-PROJECT" \
  -var="desired_count=0"
```

Destroy the infrastructure:

```bash
terraform destroy \
  -var="github_repository=abiyecomgit/CICD-ECS-PROJECT" \
  -var="desired_count=0"
```

Type `yes` when prompted.

Verify Terraform no longer tracks resources:

```bash
terraform state list
```

Also verify the AWS Console to confirm billable resources have been removed.

# Final Result

This project demonstrates a complete DevOps CI/CD workflow:

```text
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
```

Terraform manages the AWS infrastructure while GitHub Actions automates application delivery. The final result is a secure, repeatable, version-controlled, and automated CI/CD pipeline running in AWS `us-west-2`.