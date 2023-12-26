variable "aws_region" {
  description = "AWS region where to deploy the resources"
  type        = string
  default     = "us-west-1"
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
  default     = "123456789"
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  description = "Dynamo table name for locking"
  type        = string
  default     = ""
}

variable "custom_tags" {
  description = "Tags to assign to the created resources"
  type        = map(string)
  default = {
    "Terraform Managed" = "yes",
    "Environment"       = "Dev",
  }
}

variable "terratest_id" {
  description = "Random ID passed by Terratest"
  type        = string
  default     = null
}

variable "unique_backend_id" {
  description = "This is only used on the example module, it's a way to pass a append a unique id to the pre-defined structure name of bucket_name and dynamodb_table_name on main.tf "
  type        = string
  default     = ""
}
