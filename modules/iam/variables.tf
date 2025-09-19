variable "aws_codebuild_role_name" {
  description = "Name of existing shared codebuild role "
  type        = string
  default     = "codebuild_shared_role"
}