output "rds_identifier" {
  value = aws_db_instance.ecommerce_app_oltp.identifier
}

output "rds_username" {
  value = aws_db_instance.ecommerce_app_oltp.username
}

output "db_endpoint" {
  value = aws_db_instance.ecommerce_app_oltp.address
}

output "db_database" {
  value = aws_db_instance.ecommerce_app_oltp.db_name
}