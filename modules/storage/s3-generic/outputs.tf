output "s3_bucket_name" {
  value       = aws_s3_bucket.main.bucket
  description = "S3 bucket name"
}
