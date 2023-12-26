output "s3_bucket_name" {
  value       = module.s3-secure-bucket.s3_bucket_name
  description = "The name of the s3 bucket name"
}

output "dynamodb_table_name" {
  value       = module.s3-secure-bucket.dynamodb_table_name
  description = "The name of the DynamoDB table"
}
