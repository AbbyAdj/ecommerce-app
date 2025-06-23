# S3 BUCKET FOR STATIC

resource "aws_s3_bucket" "ecommerce_app_static_bucket" {
  bucket        = var.static_bucket_name
  force_destroy = var.force_destroy
}

