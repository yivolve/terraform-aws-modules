locals {
  http_port    = 80
}

// first we defined the target group
resource "aws_alb_target_group" "alb_target_group" {
  name     = var.alb_name
  port     = local.http_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  # stickiness {
  #   type            = "lb_cookie"
  #   cookie_duration = 1800
  #   enabled         = "${var.target_group_sticky}"
  # }
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
    interval            = var.interval
    path                = var.health_check_path
    port                = var.health_check_port
  }
  load_balancing_algorithm_type = var.load_balancing_algorithm
  tags = var.custom_tags
}

// Next we create the ALB:
resource "aws_lb" "main" {
  name                       = var.alb_name
  load_balancer_type         = var.load_balancer_type
  subnets                    = var.subnet_ids
  security_groups            = var.security_groups
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = var.custom_tags
}

// Now we need to define the listener and the listerner rules, each has its own terraform resource:

// Let's define a listener for this ALB using the aws_lb_listener resource. This listener configures the ALB to listen on the default HTTP port, port 80, use HTTP as the protocol, and send a simple 404 page as the default response for requests that don’t match any listener rules.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = local.http_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

# resource "aws_alb_listener_rule" "listener_rule" {
#   depends_on = ["aws_alb_target_group.alb_target_group"]

#   listener_arn = aws_lb_listener.http.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.alb_target_group.id
#   }
#   condition {
#     host_header {
#       values = [var.host_header]
#     }
#   }
# }
