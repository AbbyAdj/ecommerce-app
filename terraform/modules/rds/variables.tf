variable "db_username" {
  type        = string
  description = "oltp database username"
}

variable "db_password" {
  type        = string
  description = "oltp database password"
}

variable "rds_security_groups" {
  type = list(any)
}

variable "rds_subnet_group" {
  type = list(any)
}

variable "rds_identifier" {
  type = string
}
