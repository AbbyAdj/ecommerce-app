output "instance_ip" {
  value = aws_instance.ecommerce_app.public_ip
}

output "instance_id" {
  value = aws_instance.ecommerce_app.id
}