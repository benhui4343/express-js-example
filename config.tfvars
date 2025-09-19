# Project Details
# Specifies the unique name for the project.
# Naming conventions: ecs-{mqttBroker}-{destination}-{sensorBrand}-{sensorType}-{sensorModel}
# Example: ecs-mqtt_lora-prod_tb-arwin-drycontactout-lrs2m001
project_name = "test-express-js"

# CodeBuild and GitHub Integration
# Enables AWS CodeBuild and GitHub integrations for CI/CD pipeline.
enable_codebuild          = false
enable_githubIntegrations = false

#-----------------------------------------------------------------------------
# ECS Configuration
#-----------------------------------------------------------------------------

# ECS Cluster Configuration
# Defines the ECS cluster used for LoRa, NB, and PoE middleware services.
# Cluster Name: lora-uplink-middleware-cluster, nb-uplink-middleware-cluster, poe-uplink-middleware-cluster
ecs_cluster_name = "development-cluster"

# ECS Service Networking
# Configures subnets and security groups for ECS service communication within the VPC.
ecs_service_subnets = ["subnet-0af8b4cbff5ec9cf3"]

# Security Groups
# Uses existing security group to allow ECS communication with AWS resources in the same VPC.
# Development: sg-0347628825f83a179
# Thingsboard 3: sg-0806a247dccdab3ac
# DFI Production: sg-08ae8b2c9a26c9381 
ecs_service_security_groups = ["sg-0238301089ba7e70e"]

# ECS Task Definition - Compute Resources
# Specifies CPU and memory allocation for ECS tasks.
# CPU Options: 256 (.25 vCPU), 512 (.5 vCPU), 1024 (1 vCPU)
# Memory Options: # Memory Options: 512 MB, 1024 MB (1 GB), 2048 MB (2 GB), 3072 MB (3 GB)
ecs_cpu_size    = 256
ecs_memory_size = 512

# ECS Task Definition - Environment Variables
# Defines environment variables for the ECS task. 
ecs_task_def_env = {

}

# ECS Task Definition - Secrets
# Configures sensitive environment variables stored in AWS Secrets Manager.
# Excludes ARN prefix for secrets.
ecs_task_def_secrets = {
}

#-----------------------------------------------------------------------------
# GitHub Repository Configuration
#-----------------------------------------------------------------------------

# GitHub Repository URL
github_repo_url = "https://github.com/benhui4343/express-js-example.git"
