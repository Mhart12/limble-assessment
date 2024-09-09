data "aws_caller_identity" "current" {}

# RDS MySQL db instance for Limble
resource "aws_db_instance" "default" {
  db_subnet_group_name = aws_db_subnet_group.limble.name
  network_type         = "IPV4"
  publicly_accessible  = false
  multi_az             = false

  db_name                  = "wordpress"
  instance_class           = "db.t4g.micro"
  engine                   = "mysql"
  engine_version           = "8.0.35"
  port                     = 3306
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"

  storage_encrypted     = true
  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_throughput    = 125
  storage_type          = "gp3"
  iops                  = 3000

  parameter_group_name = "default.mysql8.0"

  kms_key_id                          = data.aws_kms_key.rds.arn
  ca_cert_identifier                  = "rds-ca-rsa2048-g1"
  iam_database_authentication_enabled = false
  manage_master_user_password         = true

  performance_insights_enabled          = false
  performance_insights_retention_period = 0
  enabled_cloudwatch_logs_exports       = []

  backup_retention_period  = 1
  backup_target            = "region"
  backup_window            = "08:49-09:19"
  delete_automated_backups = true

  apply_immediately          = false
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  skip_final_snapshot        = true
  maintenance_window         = "mon:09:53-mon:10:23"
  deletion_protection        = false

  tags = {
    Name       = "${var.name}-rds-instance"
    assessment = var.name
  }
}

# DB subnet group for the Limble RDS instance
resource "aws_db_subnet_group" "limble" {
  name        = "${var.name}-assessment-private-subnets"
  description = "All private subnets for the Limble assessment."
  subnet_ids = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value
  ]

  tags = {
    Name       = "${var.name}-rds-db-subnet-group"
    assessment = var.name
  }
}

# DB username and password credentials that the Limble RDS manages and stores in Secrets Manager
resource "aws_secretsmanager_secret" "rds" {
  description = "The secret associated with the default RDS DB instance."

  tags = {
    Name       = "${var.name}-rds-db-user-pass-secret"
    assessment = var.name
  }
}
