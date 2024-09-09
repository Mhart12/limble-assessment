data "aws_availability_zones" "available" {}

# default vpc for Limble assessment
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name       = "${var.name}-vpc"
    assessment = var.name
  }
}

# public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.0.0/20"

  tags = {
    Name       = "${var.name}-public-subnet-1"
    assessment = var.name
  }
}

# public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.16.0/20"

  tags = {
    Name       = "${var.name}-public-subnet-2"
    assessment = var.name
  }
}

# internet gateway for the public subnets
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name       = "${var.name}-igw"
    assessment = var.name
  }
}

# route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name       = "${var.name}-public-route-table"
    assessment = var.name
  }
}

# associates public subnet 1 with the route table
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

# associates public subnet 2 with the route table
resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.128.0/20"

  tags = {
    Name       = "${var.name}-private-subnet-1"
    assessment = var.name
  }
}

# private subnet 1
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.144.0/20"

  tags = {
    Name       = "${var.name}-private-subnet-2"
    assessment = var.name
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name       = "${var.name}-nat-eip"
    assessment = var.name
  }
}

# NAT Gateway for public subnet 1
resource "aws_nat_gateway" "default" {
  subnet_id = aws_subnet.public_subnet_1.id

  allocation_id = aws_eip.nat.allocation_id

  tags = {
    Name       = "${var.name}-public-nat"
    assessment = var.name
  }
}

# route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name       = "${var.name}-private-route-table"
    assessment = var.name
  }
}

# associates the private subnets with route table
resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# associates the private subnets with route table
resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}
