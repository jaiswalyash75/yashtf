resource "aws_security_group" "db" {
  name        = "yash-rds-sg"
  description = "Allow incoming database connections."

  ingress { # MySQL
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.private_sg_id
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = {
    Name = "yash-rds-sg"
  }
}


resource "aws_db_subnet_group" "default" {
  name       = "yash-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "yash-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  identifier             = var.identifier
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = "db.t2.micro"
  name                   = var.name
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.default.id
  depends_on             = [aws_db_subnet_group.default, aws_security_group.db]
}