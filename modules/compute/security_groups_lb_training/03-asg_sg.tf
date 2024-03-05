locals {
  sg_id      = aws_security_group.main.id
  cidr_block = var.cidr_block
}

resource "aws_security_group" "main" {
  name        = "${var.name}-ASG"
  description = "SG for AWS Elastic Load Balancing traning"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      Name = "${var.name}-ASG"
    },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = local.sg_id
  cidr_ipv4         = local.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = local.sg_id
  cidr_ipv4         = local.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_sg" {
  security_group_id            = local.sg_id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = local.sg_id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
