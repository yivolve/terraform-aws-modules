// Launch Template configuration

resource "aws_launch_template" "main" {
  name                   = var.name
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.vpc_security_group_id]
  user_data              = base64encode(var.user_data)
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true

    // We add a precondition block to the aws_launch_configuration resource to check that the instance type passed to instance_type is eligible for the AWS Free Tier:
    precondition {
      condition     = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS Free Tier!"
    }
  }

  instance_initiated_shutdown_behavior = "terminate"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # network_interfaces {
  #   associate_public_ip_address = var.associate_public_ip_address
  #   description                 = "Part of the ${var.name} ASG"
  #   delete_on_termination       = true
  # }

  tag_specifications {
    resource_type = "instance"

    tags = var.custom_tags
  }

  # monitoring {
  #   enabled = true
  # }

  # disable_api_stop        = true
  # disable_api_termination = true
}
