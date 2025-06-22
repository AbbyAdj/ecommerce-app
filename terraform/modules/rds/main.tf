# OLTP DATABASE

resource "aws_db_instance" "ecommerce_app_oltp" {
  allocated_storage    = 20
  db_name              = "ecommerce_app_oltp"
  engine               = "postgres"
  engine_version       = "14.12"
  identifier           = var.rds_identifier
  instance_class       = "db.t4g.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = var.rds_security_groups
  db_subnet_group_name = aws_db_subnet_group.ecommerce_app_db_subnet_group.name
}

# RDS SUBNET GROUP

resource "aws_db_subnet_group" "ecommerce_app_db_subnet_group" {
    name = "ecommerce_app_db_subnet_group"
    subnet_ids = var.rds_subnet_group
}


