terraform {
  required_version = ">= 1.0.0, < 1.5.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
}

module "roles_for_ec2" {
  source = "../../security-identity-compliance/roles_with_managed_policies"

  role_name             = var.role_name
  aws_service_principal = var.aws_service_principal
  aws_managed_policies  = var.aws_managed_policies
  custom_tags           = var.custom_tags
}

# Create an IAM instance profile which serves as an identity so it can assume the created role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.role_name[0]
  role = module.roles_for_ec2.role_names[0]
}

resource "aws_instance" "single_ec2_example" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  # This is what is called an implicit dependency
  vpc_security_group_ids = [aws_security_group.single_ec2_example_sg.id]

  // To use a reference inside of a string literal, you need to use a expression called an interpolation which has the syntax of "${...}"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true

  lifecycle {
    create_before_destroy = true

    // We wanna make sure the passed instance type is eligible for the AWS Free Tier:
    precondition {
      condition     = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS Free Tier!"
    }
  }

  tags = merge(
    var.custom_tags,
    {
      "Name" = "Single EC2 example"
    }
  )

}

resource "aws_security_group" "single_ec2_example_sg" {
  name        = "Single EC2 example"
  description = "Single EC2 example instance managed by Terraform"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.custom_tags,
    {
      "Name" = "Single EC2 example"
    }
  )
}
