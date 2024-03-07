locals {
  sg_id        = aws_security_group.main.id
  cidr_block   = var.cidr_block
  any_protocol = "-1"
  any_port     = 0
  all_ips      = "0.0.0.0/0"
}

resource "aws_security_group" "main" {
  name        = "${var.name}-ASG"
  description = "SG for AWS Elastic Load Balancing traning"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${var.name}-ASG"
    },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  for_each          = var.asg_ingress_rules
  security_group_id = local.sg_id
  cidr_ipv4         = local.cidr_block
  ip_protocol       = "tcp"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
}

# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = local.sg_id
#   cidr_ipv4         = local.cidr_block
#   ip_protocol       = "tcp"
#   from_port         = 80
#   to_port           = 80
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_alb_sg" {
#   security_group_id            = local.sg_id
#   referenced_security_group_id = aws_security_group.alb.id
#   from_port                    = 80
#   ip_protocol                  = "tcp"
#   to_port                      = 80
# }

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = local.sg_id

  cidr_ipv4   = local.all_ips
  ip_protocol = local.any_protocol
}
