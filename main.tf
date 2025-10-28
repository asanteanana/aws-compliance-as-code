# Compliance-as-Code Demo Infrastructure
# This Terraform configuration demonstrates infrastructure compliance patterns

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Random ID for unique resource naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Common tags for all resources
locals {
  common_tags = merge({
    Name        = "${var.project_name}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Owner       = "compliance-team"
    CostCenter  = "security-compliance"
    ManagedBy   = "terraform"
  }, var.tags)
}

# S3 Bucket with Compliance Controls
resource "aws_s3_bucket" "compliance_demo" {
  bucket = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"
  tags   = local.common_tags
}

# S3 Bucket Encryption (REQUIRED)
resource "aws_s3_bucket_server_side_encryption_configuration" "compliance_demo" {
  bucket = aws_s3_bucket.compliance_demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 Bucket Versioning (REQUIRED)
resource "aws_s3_bucket_versioning" "compliance_demo" {
  bucket = aws_s3_bucket.compliance_demo.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# S3 Public Access Block (REQUIRED)
resource "aws_s3_bucket_public_access_block" "compliance_demo" {
  bucket = aws_s3_bucket.compliance_demo.id

  block_public_acls       = var.enable_public_access_block
  block_public_policy     = var.enable_public_access_block
  ignore_public_acls      = var.enable_public_access_block
  restrict_public_buckets = var.enable_public_access_block

  depends_on = [aws_s3_bucket.compliance_demo]
}

# IAM Role with Least Privilege
resource "aws_iam_role" "compliance_role" {
  name = "${var.project_name}-${var.environment}-compliance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# IAM Policy with Least Privilege (No Wildcard Permissions)
resource "aws_iam_role_policy" "compliance_policy" {
  name = "${var.project_name}-${var.environment}-compliance-policy"
  role = aws_iam_role.compliance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.compliance_demo.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.compliance_logs.arn}:*"
      }
    ]
  })
}

# CloudWatch Log Group with Retention
resource "aws_cloudwatch_log_group" "compliance_logs" {
  name              = "/aws/${var.project_name}/${var.environment}"
  retention_in_days = var.log_retention_days

  tags = local.common_tags
}

# Security Group with Restrictive Rules
resource "aws_security_group" "compliance_sg" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group with restrictive compliance rules"

  # HTTPS access only
  ingress {
    description = "HTTPS from allowed CIDR blocks"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # SSH access with restrictions
  ingress {
    description = "SSH from allowed CIDR blocks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# EC2 Instance with Compliance Controls
resource "aws_instance" "compliance_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.compliance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.compliance_profile.name

  tags = local.common_tags
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "compliance_profile" {
  name = "${var.project_name}-${var.environment}-profile"
  role = aws_iam_role.compliance_role.name

  tags = local.common_tags
}
