# security group for the Limble bastion host, allows access to the RDS db, etc inside the Limble VPC
resource "aws_security_group" "bastion" {
  description = "Security group for the limble-assessment-bastion EC2 instance."

  ingress {
    description = "monica_home_ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["136.37.109.190/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.name}-bastion-host-sg"
    assessment = var.name
  }
}