resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.name}/vpc/id"
  type        = "String"
  value       = aws_vpc.default.id
  description = "The ID of the ${var.name} VPC."

  tags = {
    Name       = "${var.name}-vpc-id"
    assessment = var.name
  }
}

resource "aws_ssm_parameter" "cidr_block" {
  name        = "/${var.name}/vpc/cidr_block"
  type        = "String"
  value       = aws_vpc.default.cidr_block
  description = "The CIDR block of the ${var.name} VPC."

  tags = {
    Name       = "${var.name}-vpc-cidr-block"
    assessment = var.name
  }
}

resource "aws_ssm_parameter" "public_subnet_1" {
  name        = "/${var.name}/public/subnet/1"
  type        = "String"
  value       = aws_subnet.public_subnet_1.id
  description = "The IDs of ${var.name} public subnet 1."

  tags = {
    Name       = "${var.name}-vpc-public-subnet-1"
    assessment = var.name
  }
}

resource "aws_ssm_parameter" "public_subnet_2" {
  name        = "/${var.name}/public/subnet/2"
  type        = "String"
  value       = aws_subnet.public_subnet_2.id
  description = "The IDs of ${var.name} public subnet 2."

  tags = {
    Name       = "${var.name}-vpc-public-subnet-2"
    assessment = var.name
  }
}

resource "aws_ssm_parameter" "private_subnet_1" {
  name        = "/${var.name}/private/subnet/1"
  type        = "String"
  value       = aws_subnet.private_subnet_1.id
  description = "The IDs of ${var.name} private subnet 1."

  tags = {
    Name       = "${var.name}-vpc-private-subnet-1"
    assessment = var.name
  }
}

resource "aws_ssm_parameter" "private_subnet_2" {
  name        = "/${var.name}/private/subnet/2"
  type        = "String"
  value       = aws_subnet.private_subnet_2.id
  description = "The IDs of ${var.name} private subnet 2."

  tags = {
    Name       = "${var.name}-vpc-private-subnet-2"
    assessment = var.name
  }
}
