data "aws_ecr_repository" "repo" {
  name = var.ecr_repo_name
}

# Gets the CURRENT task definition from AWS, reflecting anything that's been deployed
# outside of Terraform (ie. CI builds).
data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.main.family
}

locals {
  container_terraformed_envs = toset([
    { name = "HEALTH_PATH", value = var.health_check_path },
    { name = "PHX_HOST", value = var.app_host },
    { name = "PORT", value = var.app_port },
    { name = "DATABASE_URL", value = "" },
  ])

  # Environment variables from other variables
  environment_variables = toset([
    {
      name  = "AWS_REGION"
      value = var.region
    },
  ])

  container_vars = {
    namespace                          = var.namespace
    region                             = var.region
    app_host                           = var.app_host
    app_port                           = var.app_port
    web_container_cpu                  = var.web_container_cpu
    web_container_memory               = var.web_container_memory
    deployment_maximum_percent         = var.deployment_maximum_percent
    deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
    aws_ecr_repository                 = data.aws_ecr_repository.repo.repository_url
    aws_ecr_tag                        = var.ecr_tag

    environment_variables = local.environment_variables
    secrets_variables     = var.secrets_variables
  }

  container_definitions = templatefile("${path.module}/service.json.tftpl", local.container_vars)

  ecs_task_execution_kms_policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey",
        ],
        Resource = "*"
      }
    ]
  }

  ecs_task_execution_secrets_manager_policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.secret_arns
      }
    ]
  }

}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.namespace}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "ecs_task_execution_kms" {
  policy = jsonencode(local.ecs_task_execution_kms_policy)
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_kms_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_kms.arn
}

resource "aws_iam_policy" "ecs_task_execution_secrets_manager" {
  policy = jsonencode(local.ecs_task_execution_secrets_manager_policy)
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_secrets_manager_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_secrets_manager.arn
}

# Task role
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.namespace}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_ecs_cluster" "main" {
  name = "${var.namespace}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.namespace}-service"
  cpu                      = var.web_container_cpu
  memory                   = var.web_container_memory
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = local.container_definitions
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "main" {
  name                               = "${var.namespace}-ecs-service"
  cluster                            = aws_ecs_cluster.main.id
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  task_definition                    = "${aws_ecs_task_definition.main.family}:${max(aws_ecs_task_definition.main.revision, data.aws_ecs_task_definition.task.revision)}"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.namespace
    container_port   = var.app_port
  }
}
