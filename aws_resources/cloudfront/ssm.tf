data "aws_ssm_parameter" "alb_dns_name" {
  name = "/${var.name}/alb/dns_name"
}