# HKT Middleware [ecare-nb-falling-detection-SENSOR52-middleware]

Collects raw data from MQTT Broker, Transforms raw data into a structured, readable format. Publishes processed data to an IoT platform. 


## 🛠️ Supported Products

### [Ecare EC60-FB-2](https://drive.google.com/file/d/1F4Me27co3pghvMcZAASknB9-5NoIcoVk/view?usp=sharing)

#### Details
- Brand: Ecare
- Sensor Type: Falling Detection
- Protocol: NB?

#### Network Specifications
- Network Protocol: MQTT (for middleware integration)


## ✨ Features

#### Middleware 
- Receives data from an MQTT broker.
- Decodes the received data to structured, readable format.
- Sends the decoded data to Thingsboard.

#### Terraform 
- AWS Elastic Container Registry (ECR)
- AWS Elastic Container Service (ECS)
- AWS CodeBuild
- GitHub integrations

#### CodeBuild
- Continuous Integration (Runs tests on pull request creation, updates, or reopening)
- Continuous Deployment (Updates ECR and ECS when code is merged to the `main` branch.)

#### Github Integrations
- Github Package Registry (Hosts shared Node.js packages)
- Github Webhook (Triggers CodeBuild)


## 📂 Repository Structure
```
├── /                  # Terraform scripts for AWS infrastructure
├── /modules           # Reusable Terraform modules (CodeBuild, ECR, ECS, GitHub)
├── /src               # Middleware source code (JavaScript)
├── buildspec.yml      # CodeBuild configuration for build and deployment
├── config.tfvars      # Project-specific middleware settings
└── providers.tf       # AWS and GitHub Terraform providers
```


## 🚀 Prerequisites
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)  (For managing AWS resources)
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) (For provisioning infrastructure as code)
- [Install Docker](https://docs.docker.com/engine/install/ubuntu/) (For containerizing the middleware application)
- [Install Node.js](https://nodejs.org/en/download) (for JavaScript development)
- [Configuring npmrc](#configuring-npmrc) (To authenticate with GitHub's npm registry.)

### Configuring `.npmrc`

You need to create an `.npmrc` file to authenticate with the npm registry. Follow these steps:

1. Create a new file at `~/.npmrc` (in your home directory).
2. Add the following content to the file:

   ```bash
   @hkt-backend-dev:registry=https://npm.pkg.github.com
   //npm.pkg.github.com/:_authToken={Your_GitHub_PAT}
   ```

   Replace `{Your_GitHub_PAT}` with your personal access token (PAT) from GitHub. 

   >💡 **Tip**: When creating the PAT, make sure to enable the **`read:packages`** permission.


## 🛠️ Getting Started

### Step 1: Clone the Repository
Clone the repository to your local machine:

```bash
git clone https://github.com/hkt-backend-dev/tesla-lora-ev-modely-tb3-middleware.git
cd tesla-lora-ev-modely-tb3-middleware
```

### Step 2: Configure config.tfvars
Edit the `config.tfvars` file to define the project-specific settings for your middleware:
1. Specify a unique name for your project.
   ```hcl
   project_name = "your-project-name"
   ```

2. Specify the subnet IDs for ECS service communication.
   ```hcl
   ecs_service_subnets = ["your-subnet-id"]
   ```

3. Specify security group IDs to allow ECS communication within the VPC
   ```hcl
   ecs_service_security_groups = ["your-security-group-id"]
   ```

4. Define CPU and memory allocation for ECS tasks
   ```hcl
   ecs_cpu_size    = 256  # Options: 256, 512, 1024
   ecs_memory_size = 512  # Options: 512 MB, 1024 MB (1 GB), 2048 MB (2 GB)
   ```

5. Define environment variables for the ECS task.
   ```hcl
   ecs_task_def_env = {
      sourceMiddleware = "your-middleware-name"
      mqttTopics       = "your/mqtt/topics"
   }
   ```
6. Define sensitive environment variables stored in AWS Paramter Store
   ```hcl
   ecs_task_def_secrets = {
      thingsboardUrl      = "/path/to/thingsboard_url"
      mqttConnctionString = "/path/to/mqtt_connection_string"
   }
   ```
7. Provide the repository URL of your middleware.
   ```hcl
   github_repo_url = "https://github.com/your-repo-url.git"
   ```

### Step 3: Middleware Development
1. Navigate to the `src` directory to begin development:
    ```bash
    cd src
    ```

2. Ensure all required files are present before deployment
    ```
    .
    ├── Dockerfile
    ├── package.json
    ├── server.js
    └── tests
        ├── mqttPayloadConvertionService.test.js
        └── testData.js
    ```
    > ⚠️ **Important**: Do not modify the `Dockerfile`.

3. Use the HKT package [@hkt-backend-dev/hkt-middleware-nodejs-packages](https://github.com/orgs/hkt-backend-dev/packages/npm/package/hkt-middleware-nodejs-packages) for standardized package management.

### Step 4: Set Up Infrastructure
1. Edit the `main.tf` file to define the Terraform backend for state management
   ```hcl
   terraform {
      backend "s3" {
         bucket         = "hktiot-terraform-s3-bucket"
         key            = "ecs/tesla/lorawan/modely/terraform.tfstate"
         region         = "ap-southeast-1"
         dynamodb_table = "terraform-state-locking"
      }
   }
   ```

2. Run the following commands to provision resources:
   ```bash
   # Initialize Terraform and download providers
   terraform init

   # Format configuration files
   terraform fmt

   # List required providers
   terraform providers

   # Preview changes
   terraform plan -var-file="config.tfvars"

   # Deploy resources
   terraform apply --auto-approve -var-file="config.tfvars"
   ```

3. Destroy Infrastructure (if required)
   ```bash
   terraform destroy -var-file="config.tfvars"
   ```

### Step 5: Continuous Integration and Continuous Deployment (CI/CD)
1. Terraform generates an `ecsTaskDef.json` file in the root directory after deployment:
   - **Do Not Delete**: This file is managed by Terraform and will be updated or removed during `terraform apply` or `terraform destroy`.
   - **Modify Carefully**: If editing manually, ensure changes align with `config.tfvars`.
   - **Version Control**: Commit changes to `ecsTaskDef.json` to the repository, as it is used by AWS CodeBuild to update ECS.

2. AWS CodeBuild uses the `buildspec.yml` file to automate tasks based on GitHub events:
   - **Pull Requests**: Runs tests on the feature branch and reports the pass/fail status.
   - **Merges into `main`**: Builds a Docker image, pushes it to AWS ECR, and updates the ECS service with the new deployment.

> ⚠️ **Important**: Only one CI/CD pipeline is supported per middleware version. For temporary versions, disable the `awsCodeBuild` and `githubIntegrations` Terraform modules and use a local backend.


## 🔗 Reference Links

