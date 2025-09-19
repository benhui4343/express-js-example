# Must add a required_providers block to every module that will create resources with this provider:
# https://registry.terraform.io/providers/integrations/github/latest/docs
# Issues related to child module didn't have a required_providers {} block
# https://github.com/integrations/terraform-provider-github/issues/876#issuecomment-1303790559
terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_repository_webhook" "codebuild_webhook" {

  repository = replace(replace(var.github_repo_url, "https://github.com/hkt-backend-dev/", ""), ".git", "")

  configuration {
    url          = var.codebuild_webhook_url
    secret       = var.codebuild_webhook_secret
    content_type = "json"
    insecure_ssl = false
  }

  events = ["push", "pull_request"]
}