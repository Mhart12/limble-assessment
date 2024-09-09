# default Limble assessment ECS cluster
resource "aws_ecs_cluster" "default" {
  name = "Limble-Assessment-Fargate"

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.default.arn
  }

  tags = {
    Name       = "${var.name}-ecs-cluster"
    assessment = var.name
  }
}

# default Cloud Map http namespace
resource "aws_service_discovery_http_namespace" "default" {
  name = "Limble-Assessment-Fargate"

  tags = {
    Name             = "${var.name}-ecs-service-discovery-http"
    assessment       = var.name
    AmazonECSManaged = "true"
  }
}

# default Limble wordpress service
resource "aws_ecs_service" "default" {
  name          = "wordpress"
  desired_count = 1

  health_check_grace_period_seconds = 30

  enable_ecs_managed_tags = true
  enable_execute_command  = true

  task_definition = aws_ecs_task_definition.default.arn

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    container_name   = "wordpress"
    container_port   = 80
    target_group_arn = aws_lb_target_group.default.arn
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs.id]
    subnets = [
      data.aws_ssm_parameter.private_subnet_1.value,
      data.aws_ssm_parameter.private_subnet_2.value
    ]
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  tags = {
    Name       = "${var.name}-ecs-wordpress-service"
    assessment = var.name
  }
}

# default Limble wordpress service
resource "aws_ecs_task_definition" "default" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_exec_task.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "314146335108.dkr.ecr.us-east-2.amazonaws.com/wordpress:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          name          = "wordpress-80-tcp"
          appProtocol   = "http"
        }
      ]
      environment = []
      secrets = [
        {
          name      = "WORDPRESS_DB_HOST"
          valueFrom = "arn:aws:ssm:us-east-2:314146335108:parameter/dev/WORDPRESS_DB_HOST"
        },
        {
          name      = "WORDPRESS_DB_NAME"
          valueFrom = "arn:aws:ssm:us-east-2:314146335108:parameter/dev/WORDPRESS_DB_NAME"
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:us-east-2:314146335108:secret:rds!db-1cd11d06-657a-4306-9206-d7676d843fba-prNDs1:password::"
        },
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = "arn:aws:secretsmanager:us-east-2:314146335108:secret:rds!db-1cd11d06-657a-4306-9206-d7676d843fba-prNDs1:username::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_limble_wordpress.name
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "ecs"
          "mode"                  = "non-blocking"
          "max-buffer-size"       = "25m"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])

  tags = {
    Name       = "${var.name}-ecs-wordpress-task-definition"
    assessment = var.name
  }
}