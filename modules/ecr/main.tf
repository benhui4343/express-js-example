## ECR 
resource "aws_ecr_repository" "target_repo" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

## local-exec for build and push of docker image
resource "null_resource" "build_push_dkr_img" {
  depends_on = [aws_ecr_repository.target_repo]
  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Starting ECR login..."
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.target_repo.repository_url}
      echo "Building Docker image..."
      DOCKER_BUILDKIT=1 docker build --secret id=npmrc,src=$HOME/.npmrc --platform linux/amd64 --provenance false -t ${aws_ecr_repository.target_repo.name}:latest  -f ./src/Dockerfile ./src
      echo "Tagging image..."
      docker tag ${aws_ecr_repository.target_repo.name}:latest  ${aws_ecr_repository.target_repo.repository_url}:latest 
      echo "Pushing to ECR..."
      docker push ${aws_ecr_repository.target_repo.repository_url}:latest 
    EOT
  }
}



