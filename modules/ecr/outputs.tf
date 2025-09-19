output "ecr_repo_name" {
  value = aws_ecr_repository.target_repo.name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.target_repo.repository_url
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.target_repo.arn
}

