data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.name}/vpc/id"
}

data "aws_ssm_parameter" "public_subnet_1" {
  name = "/${var.name}/public/subnet/1"
}

data "aws_ssm_parameter" "public_subnet_2" {
  name = "/${var.name}/public/subnet/2"
}

data "aws_ssm_parameter" "private_subnet_1" {
  name = "/${var.name}/private/subnet/1"
}

data "aws_ssm_parameter" "private_subnet_2" {
  name = "/${var.name}/private/subnet/2"
}

resource "aws_ssm_parameter" "alb_dns_name" {
  name        = "/${var.name}/alb/dns_name"
  type        = "String"
  value       = aws_lb.ecs.dns_name
  description = "The DNS name for the ALB used in front of ECS."

  tags = {
    Name       = "${var.name}-ecs-alb-dns-name"
    assessment = var.name
  }
}