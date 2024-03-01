locals {
  sg_id      = aws_security_group.main
  cidr_block = var.cidr_block
}

resource "aws_security_group" "main" {
  name        = var.name
  description = "SG fro AWS Elastic Load Balancing traning"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = local.sg_id
  cidr_ipv4         = local.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = local.sg_id
  cidr_ipv4         = local.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
