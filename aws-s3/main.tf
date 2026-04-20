# Configure the AWS variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

# Configure the AWS
provider "aws" {
  region = var.aws_region
}

# Create a new S3 bucket with encryption and versioning
resource "aws_s3_bucket" "s3bucket" {
  bucket        = "test-bucket-${random_string.bucket_suffix.result}"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Generate a random suffix for bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Upload file to S3 bucket
resource "aws_s3_object" "bucket_data" {
  bucket = aws_s3_bucket.s3bucket.bucket
  source = "./myfile.txt"
  key    = "myfile.txt"
  acl    = "private"
}