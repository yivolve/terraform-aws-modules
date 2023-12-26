terraform {
  required_version = ">= 1.4.3, < 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type     = string
}

variable "aws_account_id" {
  type     = string
}

module "terraform-aws-backend-s3-dynamodb" {
  source                = "../../../modules/storage/terraform-aws-backend-s3-dynamodb"

  aws_account_id        = var.aws_account_id
  aws_backend_name      = "from-example-module-x9y8z7"
  custom_tags           = {
    "TerraformManaged" = "true"
  }
}

output "s3_bucket_name" {
  value       = module.terraform-aws-backend-s3-dynamodb.s3_bucket_name
  description = "S3 bucket name"
}

output "dynamodb_table_name" {
  value       = module.terraform-aws-backend-s3-dynamodb.dynamodb_table_name
  description = "DynamoDB table name"
}
