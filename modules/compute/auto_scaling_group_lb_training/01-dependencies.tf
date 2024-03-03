locals {
  policy_count = length(var.aws_policy_names)
}

data "aws_ec2_instance_type" "instance" {
  instance_type = var.instance_type
}

data "aws_partition" "current" {} # see https://docs.aws.amazon.com/IAM/latest/UserGuide/reference-arns.html
