variable "enable_codebuild" {
  description = "Enable or disable the CodeBuild module"
  type        = bool
  default     = true
}

variable "enable_githubIntegrations" {
  description = "Enable or disable the Github Integrations module"
  type        = bool
  default     = true
}

variable "project_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_subnets" {
  type = list(string)
}

variable "ecs_service_security_groups" {
  type = list(string)
}

variable "ecs_cpu_size" {
  type = number
}

variable "ecs_memory_size" {
  type = number
}

variable "ecs_task_def_env" {
  type = map(string)
}

variable "ecs_task_def_secrets" {
  type = map(string)
}

variable "github_repo_url" {
  type = string
}

variable "github_owner_name" {
  type    = string
  default = "hkt-backend-dev"
}
