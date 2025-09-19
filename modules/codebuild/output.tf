output "codebuild_webhook_url" {
  value = aws_codebuild_webhook.github_side_webhook.payload_url
}

output "codebuild_webhook_secret" {
  value     = aws_codebuild_webhook.github_side_webhook.secret
  sensitive = true
}
