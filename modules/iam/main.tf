data "aws_iam_role" "codebuild_role" {
  name = var.aws_codebuild_role_name
}