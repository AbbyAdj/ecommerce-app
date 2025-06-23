output "ecommerce_app_vpc_id" {
  value = aws_vpc.ecommerce_app_vpc.id
}

output "ecommerce_app_vpc_public_subnet" {
  value = aws_subnet.ecommerce_app_vpc_public_subnets[*].id
}

output "ecommerce_app_vpc_private_subnet" {
  value = aws_subnet.ecommerce_app_vpc_private_subnets[*].id
}


