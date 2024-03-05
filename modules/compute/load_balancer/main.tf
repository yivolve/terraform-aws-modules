locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

// The first step is to create the ALB itself using the aws_lb resource:
resource "aws_lb" "main" {
  name                       = var.alb_name
  load_balancer_type         = var.load_balancer_type
  subnets                    = var.subnet_ids
  security_groups            = [aws_security_group.alb.id]
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = var.custom_tags
}

// Now we need to define the listener, the target group and the listerner rules, each has its own terraform resource:

// Let's define a listener for this ALB using the aws_lb_listener resource. This listener configures the ALB to listen on the default HTTP port, port 80, use HTTP as the protocol, and send a simple 404 page as the default response for requests that don’t match any listener rules.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = local.http_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.alb_target_group"]

  listener_arn = "${aws_alb_listener.http.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
  }
  condition {
    field  = "path-pattern"
    values = ["${var.alb_path}"]
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.alb_name} ALB"
  description = "${var.alb_name} ALB security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.alb_name} ALB"
  }
}

resource "aws_security_group_rule" "alb_sg_allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "alb_sg_allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}
