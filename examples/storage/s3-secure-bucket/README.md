# S3 Secure Bucket

## S3 Bucket and DynamoDB Table Name

This following is only valid for the example module. The name of the S3 bucket and DynamoDB table name is determined by the logic on the locals block of the main.tf file, which means that there's no need to pass a value for the bucket_name and dynamodb_table_name variables.

## How to use it

>Note: use the terraform.vars as an example to fill the needed values for this example module

time terraform init -var-file `<path to var file>`
