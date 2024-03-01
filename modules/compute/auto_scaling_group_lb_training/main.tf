locals {
  policy_count = length(var.aws_policy_names)
}


// EC2 Instance Profile Configuration
resource "aws_iam_role" "ec2_role" {
  name = "${var.name}-role"
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Action" = [
            "sts:AssumeRole"
          ],
          "Principal" = {
            "Service" = [
              "ec2.amazonaws.com"
            ]
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  count      = local.policy_count
  role       = aws_iam_role.ec2_role.id
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/${var.aws_policy_names[count.index]}"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.instance_name}-instance_profile"
  role = aws_iam_role.ec2_role.name
  provisioner "local-exec" {
    command = "echo 'Sleeps for 30 seconds to propagate the aws IAM instance profile (This a Terraform bug, see https://github.com/terraform-providers/terraform-provider-aws/issues/838)' && sleep 30"
  }
  tags = merge(
    { "Name" = "${var.instance_name}-instance_profile" },
  )
}


// Launch Template configuration

resource "aws_launch_template" "main" {
  name                   = var.name
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = base64encode("${path.module}/var.user_data") # Also: filebase64("${path.module}/var.user_data")
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
