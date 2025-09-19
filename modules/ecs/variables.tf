variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account" {
  description = "AWS account ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_cpu_size" {
  description = "ECS task CPU units"
  type        = number
}

variable "ecs_memory_size" {
  description = "ECS task memory in MiB"
  type        = number
}

variable "ecr_repo_url" {
  description = "ECR repository URL"
  type        = string
}

variable "operating_system_family" {
  description = "Docker image OS family"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "Docker image CPU arch"
  type        = string
  default     = "X86_64"
}

variable "ecs_service_subnets" {
  description = "ECS task subnet IDs"
  type        = list(string)
}

variable "ecs_service_security_groups" {
  description = "ECS task security group IDs"
  type        = list(string)
}

variable "ecs_task_def_env" {
  description = "ECS task environment vars"
  type        = map(string)
}

variable "ecs_task_def_secrets" {
  description = "ECS task secrets"
  type        = map(string)
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  type        = string
  default     = "ecsTaskExecution_shared_role"
}

variable "ecs_log_group_retention_in_days" {
  description = "CloudWatch log retention days"
  type        = number
  default     = 60
}
