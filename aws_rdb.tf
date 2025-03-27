# 既存のサブネットグループを参照
data "aws_db_subnet_group" "existing_subnet_group" {
  name = var.RDB_SUBNET_NAME
}

# 既存のセキュリティグループを参照
data "aws_security_group" "existing_sg" {
  id = var.RDB_SECURITY_GROUP_ID
}

data "aws_security_group" "existing_sg_2" {
  id = var.RDB_SECURITY_GROUP_ID_2
}

# RDSインスタンス設定
resource "aws_db_instance" "app_db" {
  identifier              = var.RDB_IDENTIFIER
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
    data.aws_security_group.existing_sg.id,
    data.aws_security_group.existing_sg_2.id
  ]

  db_subnet_group_name   = data.aws_db_subnet_group.existing_subnet_group.name

  publicly_accessible    = false
}


