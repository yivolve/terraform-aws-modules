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
  # Deny all but specific roles: https://dev.to/jansonsa/aws-how-to-deny-access-to-resources-while-allowing-a-specific-role-547b
  # S3 actions: https://docs.aws.amazon.com/AmazonS3/latest/API/API_Operations.html
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid : "TrustedPrincipals",
          Effect : "Deny",
          Principal: "*",
          Action:[
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:DeleteObject",
            "s3:GetBucketPolicy",
            "s3:PutBucketPolicy",
            "s3:DeleteBucketPolicy"
         ],
          Resource : [
            "${aws_s3_bucket.terraform_state.arn}/*",
            "${aws_s3_bucket.terraform_state.arn}",
          ]
          Condition: {
            StringNotLike: {
              "aws:PrincipalArn": var.trusted_principals
            }
          }
        },
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
  # https://dynobase.dev/dynamodb-terraform/
  name         = var.aws_backend_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  point_in_time_recovery { enabled = true }
  server_side_encryption { enabled = true }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.custom_tags
}

resource "aws_dynamodb_resource_policy" "example" {
  resource_arn = aws_dynamodb_table.terraform_locks.arn
  policy       = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "TrustedPrincipals",
          Effect : "Deny",
          Principal: "*",
          Action:[
            "dynamodb:DeleteTable",
            "dynamodb:UpdateTable",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem",
            "dynamodb:GetResourcePolicy",
            "dynamodb:DeleteResourcePolicy",
            "dynamodb:PutResourcePolicy"
         ],
          "Resource": [
            "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.aws_backend_name}"
          ]
          "Condition": {
            "StringNotLike": {
              "aws:PrincipalArn": var.trusted_principals
            }
          }
        }
      ]
    }
  )
}
