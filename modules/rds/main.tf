resource "aws_db_subnet_group" "rds" {
  name       = "${var.project}-subnet-group"
  subnet_ids = var.subnet_ids
   
   tags = {
    Name = "${var.project}-db-subnet-group"
  }
}


#RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Allow traffic to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.ecs_service_sg_id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name = "${var.project}-rds-sg"
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

  depends_on = [
    aws_db_subnet_group.rds,
    aws_security_group.rds_sg
  ]

  tags = {
    Name = "${var.project}-postgres"
  }
}
