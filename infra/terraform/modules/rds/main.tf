# Create a security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-${var.db_name}-${var.environment}-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] #TODO: This should be restricted in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-${var.db_name}-${var.environment}-sg"
    Environment = var.environment
  }
}

# Create a subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-${var.db_name}-${var.environment}-subnet-group"
  description = "Subnet group for RDS PostgreSQL instance"
  subnet_ids  = var.subnet_ids

  tags = {
    Name        = "rds-${var.db_name}-${var.environment}-subnet-group"
    Environment = var.environment
  }
}

# Create a parameter group for RDS
resource "aws_db_parameter_group" "rds_param_group" {
  name        = "rds-${var.db_name}-${var.environment}-param-group"
  family      = "postgres14"
  description = "Parameter group for RDS PostgreSQL instance"

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "shared_buffers"
    value = "16384"
  }

  tags = {
    Name        = "rds-${var.db_name}-${var.environment}-param-group"
    Environment = var.environment
  }
}

# Create the RDS instance
resource "aws_db_instance" "postgres" {
  identifier              = "rds-${var.db_name}-${var.environment}"
  engine                  = "postgres"
  engine_version          = "14.7"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = 5432
  publicly_accessible     = false
  multi_az                = var.multi_az
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  parameter_group_name    = aws_db_parameter_group.rds_param_group.name
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  apply_immediately       = true
  storage_encrypted       = true

  tags = {
    Name        = "rds-${var.db_name}-${var.environment}"
    Environment = var.environment
  }
}
