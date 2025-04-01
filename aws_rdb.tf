resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS allowing access from EC2"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    description      = "Allow MySQL access from EC2"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [data.aws_subnet.private_a.id, data.aws_subnet.private_b.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

# RDSインスタンス設定
resource "aws_db_instance" "app_db" {
  identifier              = "interview-management-terraform"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.40"
  instance_class          = "db.t4g.micro"
  username                = var.RDB_USER_NAME
  password                = var.RDB_PASSWORD
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  storage_encrypted       = false

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name

  publicly_accessible    = false
}


