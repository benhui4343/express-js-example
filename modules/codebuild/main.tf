data "aws_codestarconnections_connection" "codestar_github_connection" {
  name = var.codestar_connection_name
}

resource "aws_codebuild_project" "ecs_codebuild" {
  name         = "codebuild-${var.project_name}"
  description  = "CodeBuild to update ECS [${var.ecs_service_name}] on GitHub changes"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.codeBuild_compute_type
    image                       = var.codeBuild_image
    type                        = var.codeBuild_type
    image_pull_credentials_type = var.codeBuild_image_pull_credentials_type

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account
    }

    environment_variable {
      name  = "ECR_REPO_NAME"
      value = var.ecr_repo_name
    }

    environment_variable {
      name  = "ECS_CLUSTER_NAME"
      value = var.ecs_cluster_name
    }

    environment_variable {
      name  = "ECS_SERVICE_NAME"
      value = var.ecs_service_name
    }
  }

  source {
    type     = "GITHUB"
    location = var.github_repo_url
    auth {
      type     = "CODECONNECTIONS"
      resource = data.aws_codestarconnections_connection.codestar_github_connection.arn
    }
  }
}

resource "aws_codebuild_webhook" "github_side_webhook" {

  project_name = aws_codebuild_project.ecs_codebuild.name

  build_type = "BUILD"

  manual_creation = true

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED,PULL_REQUEST_UPDATED,PULL_REQUEST_REOPENED"
    }
    filter {
      type    = "BASE_REF"
      pattern = ".*"
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}