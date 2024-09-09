data "aws_acm_certificate" "ecs_alb" {
  domain = "*.assessment-sandbox.com"
}

# public-facing ALB for Limble ECS cluster
resource "aws_lb" "ecs" {
  name               = "ecs-wordpress"
  load_balancer_type = "application"
  internal           = false

  subnets = [
    data.aws_ssm_parameter.public_subnet_1.value,
    data.aws_ssm_parameter.public_subnet_2.value
  ]

  tags = {
    Name       = "${var.name}-alb"
    assessment = var.name
  }
}

# HTTP Redirect listener for Limble ALB
resource "aws_lb_listener" "ecs_http" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    order = 1
    type  = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name       = "${var.name}-alb-listener-http"
    assessment = var.name
  }
}

# HTTPS listener for Limble ALB
resource "aws_lb_listener" "ecs_https" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.ecs_alb.arn

  default_action {
    type = "forward"

    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.default.arn
        weight = 1
      }
    }
  }

  tags = {
    Name       = "${var.name}-alb-listener-https"
    assessment = var.name
  }
}

# listener rule for Limble wordpress
resource "aws_lb_listener_rule" "wordpress" {
  listener_arn = aws_lb_listener.ecs_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }

  condition {
    host_header {
      values = ["ecs.assessment-sandbox.com"]
    }
  }

  tags = {
    Name       = "${var.name}-alb-https-rule"
    assessment = var.name
  }
}

# Limble wordpress target group
resource "aws_lb_target_group" "default" {
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  name                 = "wordpress-tg"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  target_type                   = "ip"
  ip_address_type               = "ipv4"
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/wp-admin/images/wordpress-logo.svg"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  tags = {
    Name       = "${var.name}-alb-tg"
    assessment = var.name
  }
}