# CREATE EC2 AMI

# might consider Amazon linux, but I am sticking to ubuntu for now,
data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"]

  # Ubuntu AMI ID search
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# CREATE EC2 INSTANCE

resource "aws_instance" "ecommerce_app" {
  ami                  = data.aws_ami.ubuntu_24_04.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  user_data = templatefile("${path.root}/../../../scripts/run_ec2.sh", {
    GITHUB_TOKEN     = var.github_token,
    DB_PORT          = var.db_port,
    DB_USERNAME      = var.db_username,
    DB_ENDPOINT      = var.db_endpoint,
    DB_DATABASE      = var.db_database,
    DB_PASSWORD      = var.db_password,
    FLASK_ENV        = var.flask_env,
    S3_STATIC_BUCKET = var.s3_static_storage_bucket
  })
  user_data_replace_on_change = var.user_data_replace_on_change
  vpc_security_group_ids      = var.ec2_security_groups
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name = var.ec2_instance_name
  }
}