# <----------ECS SG --------->

# security group for the Limble ECS service and tasks to allow ALB access
resource "aws_security_group" "ecs" {
  description = "Allow wordpress traffic from ALB"

  tags = {
    Name       = "${var.name}-rds-instance-sg"
    assessment = var.name
  }
}

# ingress for http from alb
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = "sg-0615e5216d3be8a16"
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80

  tags = {
    Name       = "${var.name}-ecs-service-sg-ingress"
    assessment = var.name
  }
}

# allow all outbound traffic from ECS service and task
resource "aws_vpc_security_group_egress_rule" "all_traffic" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name       = "${var.name}-ecs-service-sg-egress"
    assessment = var.name
  }
}

# <----------ALB SG --------->

# security group for the Limble ALB in front of ECS
resource "aws_security_group" "alb" {
  description = "ECS security group for alb."

  tags = {
    Name       = "${var.name}-rds-instance-sg"
    assessment = var.name
  }
}

# ingress for https from alb
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name       = "${var.name}-alb-sg-ingress"
    assessment = var.name
  }
}

# ingress for http from alb
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name       = "${var.name}-alb-sg-ingress"
    assessment = var.name
  }
}

# allow all outbound traffic from ECS service and task
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name       = "${var.name}-ecs-service-sg-egress"
    assessment = var.name
  }
}
