data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.name}/vpc/id"
}

data "aws_ssm_parameter" "cidr_block" {
  name = "/${var.name}/vpc/cidr_block"
}

data "aws_ssm_parameter" "private_subnet_1" {
  name = "/${var.name}/private/subnet/1"
}

data "aws_ssm_parameter" "private_subnet_2" {
  name = "/${var.name}/private/subnet/2"
}

resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/${var.name}/rds_instance/endpoint"
  type        = "String"
  value       = aws_db_instance.default.endpoint
  description = "The connection endpoint in address:port format."

  tags = {
    Name       = "${var.name}-rds-db-endpoint"
    assessment = var.name
  }
}