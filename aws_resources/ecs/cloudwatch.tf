# default log group for the Limble ECS wordpress service
resource "aws_cloudwatch_log_group" "ecs_limble_wordpress" {
  name = "/ecs/limble-assessment-wordpress"

  log_group_class   = "STANDARD"
  retention_in_days = 0

  tags = {
    Name       = "${var.name}-ecs-wordpress-cloudwatch-log-group"
    assessment = var.name
  }
}