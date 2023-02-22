This document contains a description of the requisite software and hardware needed to run infrastructure for an [example app](https://github.com/Nihisil/nimble-devops-ic-app).

Infrastructure diagram is available [here](Infrastructure Documentation)

## Required hardware

All parts are hosted on AWS and they rely heavily on AWS services. It would require complete restructuring to migrate them to a different cloud provider.

RDS instance type:
- `db.t4g.medium`

ElastiCache instance type:
- `cache.t3.small`

ECS Fargate instance type:
- Refer to `ecs` variable description below in this documentation

## Required software

Terraform Cloud is used to make modifications to the infrastructure.

Once the code is pushed to the appropriate branch, a Terraform plan is performed for the related infrastructure version.

Following reviewing the output of the Terraform plan, the administrator should apply the changes on Terraform Cloud to make them implement in real life.

- Commits to the `develop` branch activate the plan for the staging version of infrastructure
- Commits to the `main` branch activate the plan for the production version of infrastructure

### Workspaces configuration

Three workspaces must be configured:
- `shared` for shared between environment services
- `staging` for the staging version of the application
- `production` for the production version of the application

Version control connection must be set up for each workspace.

`shared` workspace should point to the `shared` folder and both `staging` and `production` workspaces should point to the `base` folder.

### Required variables

All variables should be set as Terraform variables, and the 'sensitive' flag should be applied where necessary.

These variables should be shared between all workspaces:

| Variable                      | Value                     |
|:------------------------------|---------------------------|
| aws_access_key                | SENSITIVE                 |
| aws_secret_key                | SENSITIVE                 |
| app_name                      | alex-ic                   |
| app_port                      | 4000                      |
| bastion_allowed_ip_connection | SENSITIVE                 |
| ecs                           | refer to code below table |
| health_check_path             | /_health/readiness        |
| owner                         | alex-ic                   |

`ecs` variable:
```HCL
{
  web_container_cpu = 256
  web_container_memory = 512
  task_desired_count = 3
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50
  max_capacity = 6
  max_cpu_threshold = 60
}
```

These variables should be configured for `staging` and `production` workspaces.

| Variable        | Value     |
|:----------------|-----------|
| environment     | staging   |
| secret_key_base | SENSITIVE |
| rds_username    | SENSITIVE |
| rds_password    | SENSITIVE |

These variables should be configured for `shared` workspace.

| Variable        | Value      |
|:----------------|------------|
| environment     | production |
