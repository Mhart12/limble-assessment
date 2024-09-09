# <---------BASTION IAM ROLE----------->

# default role for the bastion host
resource "aws_iam_role" "bastion" {
  name = "bastion-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name       = "${var.name}-bastion-host-iam-role"
    assessment = var.name
  }
}

# Attaches an SSM policy to the bastion IAM role for session access
resource "aws_iam_role_policy_attachment" "bastion_ssm_attach" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM profile that the bastion can utilize
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion.name

  tags = {
    Name       = "${var.name}-bastion-host-instance-profile"
    assessment = var.name
  }
}