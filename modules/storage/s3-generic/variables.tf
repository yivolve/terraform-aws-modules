variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string
}

variable "bucket_policy" {
  description = "AWS S3 bucket name"
  type        = any
}

variable "force_destroy" {
  description = "Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation."
  type        = bool
  default     = false
}

variable "custom_tags" {
  description = "Custom Tags"
  type        = map(string)
  default     = {}
}
