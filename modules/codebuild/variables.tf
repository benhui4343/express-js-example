variable "codestar_connection_name" {
  description = "CodeStar connection name"
  type        = string
  default     = "hktbackend-FGPAT-Connection"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "codebuild_role_arn" {
  description = "CodeBuild IAM role ARN"
  type        = string
}

variable "codebuild_artifacts_type" {
  description = "Build artifacts type"
  type        = string
  default     = "NO_ARTIFACTS"
}

variable "codeBuild_compute_type" {
  description = "Build compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codeBuild_image" {
  description = "Docker image for build"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"

}

variable "codeBuild_type" {
  description = "Build environment type"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "codeBuild_image_pull_credentials_type" {
  description = "Image pull credentials type"
  type        = string
  default     = "CODEBUILD"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account" {
  description = "AWS account ID"
  type        = string
  sensitive   = true
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repo HTTPS URL"
  type        = string
}
