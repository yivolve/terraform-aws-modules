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
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid : "TrustedPrincipals",
          Effect : "Deny",
          "Principal": "*",
          Action : "s3:*",
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
  name         = var.aws_backend_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

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
          "Sid": "Statement1",
          "Effect": "Allow",
          "Principal": {
            "AWS": var.trusted_principals
          },
          "Action": [
            "dynamodb:*"
          ],
          "Resource": [
            "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.aws_backend_name}"
          ]
        }
      ]
    }
  )
}
