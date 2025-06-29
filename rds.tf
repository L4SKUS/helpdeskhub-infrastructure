resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "helpdeskhub_users_db" {
  allocated_storage    = 7
  identifier           = "helpdeskhub-users-db"
  engine               = "postgres"
  engine_version       = "17.4"
  instance_class       = "db.t4g.micro"
  username             = "postgres"
  password             = "postgres"
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  publicly_accessible  = true
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.arn

  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_db_instance" "helpdeskhub_tickets_db" {
  allocated_storage    = 7
  identifier           = "helpdeskhub-tickets-db"
  engine               = "postgres"
  engine_version       = "17.4"
  instance_class       = "db.t4g.micro"
  username             = "postgres"
  password             = "postgres"
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  publicly_accessible  = true
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.arn

  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_db_instance" "helpdeskhub_comments_db" {
  allocated_storage    = 7
  identifier           = "helpdeskhub-comments-db"
  engine               = "postgres"
  engine_version       = "17.4"
  instance_class       = "db.t4g.micro"
  username             = "postgres"
  password             = "postgres"
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  publicly_accessible  = true
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.arn

  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}
