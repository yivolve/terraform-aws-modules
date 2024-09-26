variable "aws_region" {
  description = "Working AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

variable "aws_backend_name" {
  description = "Backend name"
  type        = string
}

variable "custom_tags" {
  description = "Custom Tags"
  type        = map(string)
  default     = {}
}
variable "trusted_principals" {
  description = "Trusted principals"
  type = list(string)
}

variable "bucket_force_destroy" {
  description = "Force bucket destruction"
  type        = bool
}

