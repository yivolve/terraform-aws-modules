resource "aws_security_group" "main" {
  name        = var.name
  description = "SG fro AWS Elastic Load Balancing traning"
  vpc_id      = var.vpc_id
  tags        = var.tags
}
