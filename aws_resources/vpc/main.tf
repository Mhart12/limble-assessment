data "aws_availability_zones" "available" {
  state = "available"
}

# default vpc
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name       = "${var.name}-vpc"
    assessment = var.name
  }
}

# public subnets
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.default.id
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name       = "${var.name}-public-subnet-${count.index + 1}"
    assessment = var.name
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name       = "${var.name}-private-subnet-${count.index + 1}"
    assessment = var.name
  }
}

# control plane subnets for EKS
resource "aws_subnet" "control_plane_subnets_eks" {
  count             = 2
  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + 4)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name       = "${var.name}-control-plane-subnet-${count.index + 1}"
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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name       = "${var.name}-public-route-table"
    assessment = var.name
  }
}

# associates the public subnets with the route table
resource "aws_route_table_association" "public_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}