variable "environment" {
  type    = string
  default = "dev"
}

variable "ec2_instance_name" {
  type = string
}

variable "static_storage_bucket" {
  type = string
}

variable "force_destroy" {
  type = bool
}

variable "db_credentials_secret_name" {
  type = string
}

variable "github_secret_name" {
  type = string
}

variable "my_ip_address" {
  type = string
}

variable "key_name" {
  type = string
}

variable "rds_identifier" {
  type = string
}

variable "flask_env" {
  type = string
}