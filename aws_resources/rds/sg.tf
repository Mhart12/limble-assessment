# security group for the Limble RDS mysql db instance, allows everything under the Limble VPC access to MySQL
resource "aws_security_group" "rds" {
  description = "Created by RDS management console"

  ingress {
    description = "Allow MySQL access from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_ssm_parameter.cidr_block.value]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.name}-rds-instance-sg"
    assessment = var.name
  }
}