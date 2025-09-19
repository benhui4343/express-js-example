output "ecs_cluster_name" {
  value = data.aws_ecs_cluster.target_ecs_cluster.cluster_name
}

output "ecs_service_name" {
  value = aws_ecs_service.target_ecs_service.name
}
