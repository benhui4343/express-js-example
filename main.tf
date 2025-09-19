terraform {
  required_version = "~> 1.3"

  # IMPORTANT: For local development, remove the following backend configuration block
  # Backend Configuration Details:
  # - S3 Bucket: hktiot-terraform-s3-bucket (fixed, do not modify)
  # - State File Path Convention: ecs/{sensorBrand}/{NetworkProtocol}/{DeviceType}/{DeviceModel}/terraform.tfstate
  #   Example: ecs/arwin/nb/drycontactout/sen2m001/terraform.tfstate
  # - DynamoDB Table: terraform-state-locking (fixed, do not modify)
  backend "s3" {
    bucket         = "hktiot-terraform-s3-bucket"             # S3 bucket where the state file is stored
    key            = "ecs/test-express-js-service/terraform.tfstate" # Path to the state file in the bucket
    region         = "ap-southeast-1"                         # AWS region
    dynamodb_table = "terraform-state-locking"                # DynamoDB table for locking
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

#-----------------------------------------------------------------------------
# IAM
#-----------------------------------------------------------------------------
module "awsIAM" {
  source       = "./modules/iam"
}

#-----------------------------------------------------------------------------
# AWS ECR
#-----------------------------------------------------------------------------
module "awsEcr" {
  source       = "./modules/ecr"
  aws_region   = data.aws_region.current.name
  project_name = var.project_name
}

#-----------------------------------------------------------------------------
# AWS ECS
#-----------------------------------------------------------------------------
module "awsEcs" {
  source      = "./modules/ecs"
  aws_region  = data.aws_region.current.name
  aws_account = data.aws_caller_identity.current.account_id

  project_name = var.project_name

  ecr_repo_url = module.awsEcr.ecr_repo_url

  ecs_cluster_name            = var.ecs_cluster_name
  ecs_cpu_size                = var.ecs_cpu_size
  ecs_memory_size             = var.ecs_memory_size
  ecs_service_subnets         = var.ecs_service_subnets
  ecs_service_security_groups = var.ecs_service_security_groups
  ecs_task_def_env            = var.ecs_task_def_env
  ecs_task_def_secrets        = var.ecs_task_def_secrets

  depends_on = [module.awsEcr]
}

#-----------------------------------------------------------------------------
# AWS CodeBuild
#-----------------------------------------------------------------------------
module "awsCodeBuild" {
  count = var.enable_codebuild ? 1 : 0

  source       = "./modules/codebuild"
  project_name = var.project_name
  aws_region   = data.aws_region.current.name
  aws_account  = data.aws_caller_identity.current.account_id

  codebuild_role_arn = module.awsIAM.codebuild_iam_role_arn

  github_repo_url = var.github_repo_url

  ecr_repo_name    = module.awsEcr.ecr_repo_name
  ecs_cluster_name = module.awsEcs.ecs_cluster_name
  ecs_service_name = module.awsEcs.ecs_service_name
}

#-----------------------------------------------------------------------------
# Github Integration
#-----------------------------------------------------------------------------
module "githubIntegrations" {
  count = var.enable_githubIntegrations ? 1 : 0

  source                   = "./modules/github"
  github_repo_url          = var.github_repo_url
  codebuild_webhook_url    = module.awsCodeBuild[0].codebuild_webhook_url
  codebuild_webhook_secret = module.awsCodeBuild[0].codebuild_webhook_secret
  depends_on               = [module.awsCodeBuild]
}

