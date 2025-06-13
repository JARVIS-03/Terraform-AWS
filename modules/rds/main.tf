resource "aws_db_subnet_group" "rds" {
  name       = "${var.project}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Allow traffic to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Need to update based on our CIDR requirements
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "${var.project}-db"
  engine                  = "postgres"
  engine_version          = "15.9"
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  allocated_storage       = 20
  storage_encrypted       = true
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 7
  multi_az                = false  # Set to true for prod
  deletion_protection     = false  # Set to true for prod
}
