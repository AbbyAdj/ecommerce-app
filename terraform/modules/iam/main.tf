# EC2

resource "aws_iam_role" "ec2_combined_role" {
  name = "ec2_combined_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# COMBINED POLICY

resource "aws_iam_policy" "ec2_combined_policy" {
  name = "ec2_combined_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Secrets Manager permissions
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      },

      # S3 permissions
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:ListBuckets",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Resource = [
          "${var.static_s3_bucket_arn}_*",
          "${var.static_s3_bucket_arn}_*/*"
        ]
      },

      # RDS IAM auth (optional — only if using IAM DB auth)
      {
        Effect = "Allow",
        Action = [
          "rds-db:connect"
        ],
        Resource = "arn:aws:rds-db:${data.aws_region.current_region.name}:${data.aws_caller_identity.my_caller_id.account_id}:dbuser:${var.rds_identifier}/${var.rds_username}"
      }
    ]
  })
}

# ROLE -> POLICY

resource "aws_iam_role_policy_attachment" "ec2_combined_policy_attachment" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = aws_iam_policy.ec2_combined_policy.arn
}

# INSTANCE PROFILE

resource "aws_iam_instance_profile" "ec2_combined_profile" {
  name = "ec2_combined_profile"
  role = aws_iam_role.ec2_combined_role.name
}

# DATA NEEDED

data "aws_region" "current_region" {}

data "aws_caller_identity" "my_caller_id" {}