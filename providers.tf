provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ssm_parameter" "ssm_codebuild_github_fgpat" {
  name = "/ecs/github/FGPAT"
}

provider "github" {
  owner = var.github_owner_name
  token = data.aws_ssm_parameter.ssm_codebuild_github_fgpat.value
}
