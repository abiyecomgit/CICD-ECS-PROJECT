resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}


# Trust policy that allows GitHub Actions to assume the IAM role
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    # GitHub OIDC token must be intended for AWS STS
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    # Restrict access to this GitHub repository
    # and the production environment
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:abiyecomgit@187072991/CICD-ECS-PROJECT@1354719337:environment:production"
      ]
    }
  }
}


# IAM role used by GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Name = "${var.project_name}-github-actions-role"
  }
}


# Permissions required by the CI/CD pipeline
data "aws_iam_policy_document" "github_actions_permissions" {

  # Allows authentication to Amazon ECR
  statement {
    sid    = "ECRAuthorization"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }


  # Allows GitHub Actions to push Docker images
  # only to this project's ECR repository
  statement {
    sid    = "ECRPush"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      aws_ecr_repository.app.arn
    ]
  }


  # Allows GitHub Actions to deploy new ECS task revisions
  statement {
    sid    = "ECSDeployment"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]

    resources = ["*"]
  }


  # Allows ECS task and execution roles to be passed
  # when registering the new task definition
  statement {
    sid    = "PassECSRoles"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.ecs_execution.arn,
      aws_iam_role.ecs_task.arn
    ]
  }
}


# Attach permissions directly to the GitHub Actions role
resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = data.aws_iam_policy_document.github_actions_permissions.json
}