provider "aws" {
  region = var.aws_region
}

locals {
  backend_common_name = var.terratest_id == null ? "${var.aws_account_id}-${var.aws_region}-${var.unique_backend_id}" : "${var.aws_account_id}-${var.aws_region}-${var.terratest_id}-temp-statefile"
}

module "s3-secure-bucket" {
  source = "../../../modules/data-stores/s3-secure-bucket"

  aws_region          = var.aws_region
  aws_account_id      = var.aws_account_id
  bucket_name         = local.backend_common_name
  dynamodb_table_name = local.backend_common_name
  custom_tags         = var.custom_tags
}
