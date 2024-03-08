resource "random_id" "main" {
  byte_length = 3
}

resource "aws_autoscaling_group" "main" {
  name                      = var.name
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  force_delete              = false // Check https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#force_delete
  target_group_arns         = var.target_group_arns
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  instance_refresh { # Use instance refresh to roll out changes to the ASG
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    postcondition {
      condition     = length(self.availability_zones) > 1
      error_message = "You must use more than one AZ for high availability!"
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-ASG-${random_id.main.id}"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_attachment" "lb_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.main.name
  lb_target_group_arn    = var.alb_target_group_arn
  lifecycle {
    ignore_changes = [lb_target_group_arn]
  }
}
