variable "aws_region" {
  description = "AWS region where to deploy the resources"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Dynamo table name for locking"
  type        = string
}

variable "custom_tags" {
  description = "Tags to assign to the created resources"
  type        = map(string)
}
