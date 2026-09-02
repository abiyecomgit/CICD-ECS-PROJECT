variable "project_name" {
  description = "Name used for project resources"
  type        = string
  default     = "cicd-ecs-project"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.20.2.0/24"
}

variable "private_subnet_a_cidr" {
  type    = string
  default = "10.20.11.0/24"
}

variable "private_subnet_b_cidr" {
  type    = string
  default = "10.20.12.0/24"
}

variable "container_port" {
  description = "Port used by the Flask application"
  type        = number
  default     = 5000
}

variable "container_cpu" {
  type    = number
  default = 256
}

variable "container_memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "image_tag" {
  description = "Docker image tag used by the ECS task"
  type        = string
  default     = "bootstrap"
}