output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "S3 bucket name"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "DynamoDB table name"
}
