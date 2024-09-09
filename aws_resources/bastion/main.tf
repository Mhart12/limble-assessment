# EC2 for the Limble bastion host
resource "aws_instance" "bastion" {
  instance_type = "t2.micro"
  ami           = "ami-0490fddec0cbeb88b"

  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion.key_name
  iam_instance_profile        = aws_iam_instance_profile.bastion_instance_profile.name

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name       = "${var.name}-bastion-host"
    assessment = var.name
  }
}

# key pair for the Limble bastion host
resource "aws_key_pair" "bastion" {
  public_key = ""

  tags = {
    Name       = "${var.name}-bastion-host-key-pair"
    assessment = var.name
  }
}