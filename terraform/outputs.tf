output "aws_region" {
  value = "us-west-2"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "application_url" {
  value = "http://${aws_lb.app.dns_name}"
}
output "github_actions_role_arn" {
  description = "IAM role used by GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}