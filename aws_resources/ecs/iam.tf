# <---------ECS IAM TASK ROLE----------->

# default ECS wordpress task role
resource "aws_iam_role" "ecs_task" {
  name        = "ecstaskrole"
  description = "Allows ECS tasks to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name       = "${var.name}-ecs-wordpress-task-iam-role"
    assessment = var.name
  }
}

# Attaches an EC2 Container Service policy to the ECS task IAM role
resource "aws_iam_role_policy_attachment" "ecs_ec2_perms" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# Attaches the SSM Managed Instance Core policy to the ECS task IAM role
resource "aws_iam_role_policy_attachment" "ecs_ssm_managed_instance" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attaches the secrets manager policy to the ECS task IAM role
resource "aws_iam_role_policy_attachment" "ecs_secrets_manager" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# <---------ECS IAM TASK EXEC ROLE----------->

# default ECS exec task role
resource "aws_iam_role" "ecs_exec_task" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name       = "${var.name}-ecs-wordpress-exec-task-iam-role"
    assessment = var.name
  }
}

# Attaches ECS Task Exec policy to the ECS exec task IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_exec_perms" {
  role       = aws_iam_role.ecs_exec_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attaches the secrets manager policy to the ECS exec task IAM role
resource "aws_iam_role_policy_attachment" "ecs_exec_ssm_ro" {
  role       = aws_iam_role.ecs_exec_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Attaches the secrets manager policy to the ECS exec task IAM role
resource "aws_iam_role_policy_attachment" "ecs_exec_secrets_manager" {
  role       = aws_iam_role.ecs_exec_task.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}