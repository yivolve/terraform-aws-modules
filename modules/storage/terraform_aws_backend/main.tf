resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.aws_backend_name
  tags          = var.custom_tags
  force_destroy = var.bucket_force_destroy
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_configuration" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "EnforcedTLS"
          Effect    = "Deny"
          Principal = "*"
          Action    = "s3:*"
          Resource = [
            "${aws_s3_bucket.terraform_state.arn}/*",
            "${aws_s3_bucket.terraform_state.arn}",
          ]
          Condition = {
            Bool = {
              "aws:SecureTransport" = "false"
            }
          }
        },
        {
          Sid : "RootAccess",
          Effect : "Allow",
          Principal : {
            "AWS" : "arn:aws:iam::${var.aws_account_id}:root"
          },
          Action : "s3:*",
          Resource : [
            "${aws_s3_bucket.terraform_state.arn}/*",
            "${aws_s3_bucket.terraform_state.arn}",
          ]
        },
        {
          Sid       = "DenyInsecureProtoliVersions"
          Effect    = "Deny"
          Principal = "*"
          Action    = "s3:*"
          Resource = [
            "${aws_s3_bucket.terraform_state.arn}/*",
            "${aws_s3_bucket.terraform_state.arn}",
          ]
          Condition = {
            NumericLessThan = {
              "s3:TlsVersion" : 1.2
            }
          }
        }
      ]
  })
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.aws_backend_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.custom_tags
}
