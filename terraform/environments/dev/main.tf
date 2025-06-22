# export TF_VAR_my_ip_address=$(curl -s https://api.ipify.org)/32

module "secrets_manager" {
  source = "../../modules/secrets-manager"
  db_credentials_secret_name = var.db_credentials_secret_name
  github_secret_name = var.github_secret_name
}

module "s3" {
  source = "../../modules/s3"
  static_bucket_name = var.static_storage_bucket
  force_destroy = var.force_destroy
}

module "vpc" {
  source = "../../modules/vpc"
}

module "security_groups" {
  source = "../../modules/security_groups"
  my_ip_address = var.my_ip_address
  vpc_id = module.vpc.ecommerce_app_vpc_id
}

module "rds" {
  source = "../../modules/rds"
  db_password = module.secrets_manager.db_password
  db_username = module.secrets_manager.db_username
  rds_security_groups = [module.security_groups.rds_security_group]
  rds_subnet_group = module.vpc.ecommerce_app_vpc_private_subnet
  rds_identifier = var.rds_identifier
}

module "iam" {
  source = "../../modules/iam"
  rds_identifier = module.rds.rds_identifier
  rds_username = module.rds.rds_username
  static_s3_bucket_arn = module.s3.static_s3_bucket_arn
}

module "ec2" {
  source = "../../modules/ec2"
  db_database            = module.rds.db_database
  db_endpoint            = module.rds.db_endpoint
  db_password            = module.secrets_manager.db_password
  db_username            = module.rds.rds_username
  ec2_instance_name      = var.ec2_instance_name
  ec2_security_groups    = [module.security_groups.ec2_security_group]
  github_token           = module.secrets_manager.github_token
  iam_instance_profile   = module.iam.iam_instance_profile_name
  s3_static_storage_bucket = var.static_storage_bucket
  subnet_id              = module.vpc.ecommerce_app_vpc_public_subnet[0]
  key_name = var.key_name
  flask_env = var.flask_env
}










