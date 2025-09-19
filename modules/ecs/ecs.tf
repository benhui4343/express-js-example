## Existing ecs cluster
data "aws_ecs_cluster" "target_ecs_cluster" {
  cluster_name = var.ecs_cluster_name
}

# Existing ECS task exection role
data "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role_name
}

# CloudWatch Logs Group for Task definition
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project_name}-task-def"
  retention_in_days = var.ecs_log_group_retention_in_days
}

# ECS Task Definition
resource "aws_ecs_task_definition" "target_ecs_task_def" {
  family                   = "${var.project_name}-task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu_size
  memory                   = var.ecs_memory_size
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-task-def"
      image     = "${var.ecr_repo_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        for name, value in var.ecs_task_def_env : {
          name  = name
          value = value
        }
      ]
      secrets = [
        for name, value in var.ecs_task_def_secrets : {
          name      = name
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter${value}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}

# ECS Service
resource "aws_ecs_service" "target_ecs_service" {
  name            = "${var.project_name}-service"
  cluster         = data.aws_ecs_cluster.target_ecs_cluster.arn
  task_definition = aws_ecs_task_definition.target_ecs_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.ecs_service_subnets
    security_groups  = var.ecs_service_security_groups
    assign_public_ip = false
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true # Roll back last deployment that completed successfully if a service deployment fails
  }

  depends_on = [aws_ecs_task_definition.target_ecs_task_def]

}

# Output task definition as JSON file
resource "local_file" "task_def_json" {
  content = replace(
    jsonencode({
      family                  = aws_ecs_task_definition.target_ecs_task_def.family
      requiresCompatibilities = aws_ecs_task_definition.target_ecs_task_def.requires_compatibilities
      networkMode             = aws_ecs_task_definition.target_ecs_task_def.network_mode
      cpu                     = aws_ecs_task_definition.target_ecs_task_def.cpu
      memory                  = aws_ecs_task_definition.target_ecs_task_def.memory
      executionRoleArn        = aws_ecs_task_definition.target_ecs_task_def.execution_role_arn
      taskRoleArn             = aws_ecs_task_definition.target_ecs_task_def.task_role_arn
      containerDefinitions    = jsondecode(aws_ecs_task_definition.target_ecs_task_def.container_definitions)
      runtimePlatform = {
        operatingSystemFamily = aws_ecs_task_definition.target_ecs_task_def.runtime_platform[0].operating_system_family
        cpuArchitecture       = aws_ecs_task_definition.target_ecs_task_def.runtime_platform[0].cpu_architecture
      }
    }),
    var.aws_account,
    "{AWS_ACCOUNT_ID}"
  )

  filename = "${path.root}/ecsTaskDef.json"

  depends_on = [aws_ecs_task_definition.target_ecs_task_def]
}
