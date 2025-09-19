output "codebuild_iam_role_arn" {
  value = data.aws_iam_role.codebuild_role.arn
}