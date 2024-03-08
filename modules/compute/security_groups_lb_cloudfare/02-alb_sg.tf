locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
  alb_ingress_cidr_ipv4 = [
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "108.162.192.0/18",
    "131.0.72.0/22",
    "141.101.64.0/18",
    "162.158.0.0/15",
    "172.64.0.0/13",
    "173.245.48.0/20",
    "188.114.96.0/20",
    "190.93.240.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17"
  ]
  alb_ingress_ipv6_cidr_blocks = [
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32"
  ]
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-ALB"
  description = "${var.name} ALB security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.name}-ALB"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "alb_sg_allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

# resource "aws_security_group_rule" "alb_sg_allow_all_outbound" {
#   type              = "egress"
#   security_group_id = aws_security_group.alb.id

#   from_port   = local.any_port
#   to_port     = local.any_port
#   protocol    = local.any_protocol
#   cidr_blocks = local.all_ips
# }

resource "aws_security_group_rule" "alb_sg_allow_cloudfare_ip_range" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks      = local.alb_ingress_cidr_ipv4
  ipv6_cidr_blocks = local.alb_ingress_ipv6_cidr_blocks
}
