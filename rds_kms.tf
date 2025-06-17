resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "rds-key"
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/rds-key"
  target_key_id = aws_kms_key.rds.key_id
}
