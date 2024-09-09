data "aws_kms_key" "rds" {
  key_id = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:alias/aws/rds"
}

data "aws_kms_key" "secrets_manager" {
  key_id = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:alias/aws/secretsmanager"
}
