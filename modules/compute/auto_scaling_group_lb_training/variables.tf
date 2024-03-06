variable "name" {
  type    = string
  default = "test"
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string

  // The validation block here is not as good as the precondition block used on the aws_launch_configuration resource, hence commenting
  # validation {
  #   condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
  #   error_message = "Only free tier is allowed: t2.micro | t3.micro."
  # }
}

variable "instance_name" {
  type        = string
  description = "Name to give to the instance"
  default     = "aws-lb-training"
}

variable "aws_policy_names" {
  type = list(string)
}

variable "vpc_security_group_id" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 1

  validation {
    condition     = var.min_size > 0
    error_message = "ASGs can't be empty or we'll have an outage!"
  }

  validation {
    condition     = var.min_size <= 10
    error_message = "ASGs must have 10 or fewer instances to keep costs down."
  }
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The desired capacity number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

# variable "enable_autoscaling" {
#   description = "If set to true, enable auto scaling"
#   type        = bool
# }

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "target_group_arns" {
  description = "(Optional) Set of aws_alb_target_group ARNs, for use with Application or Network Load Balancing. To remove all target group attachments an empty list should be specified. Chech:  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#target_group_arns"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "(Optional) EC2 or ELB. Controls how health checking is done."
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "(Optional, Default: 300) Time (in seconds) after instance comes into service before checking health."
  type        = number
  default     = 300
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

# variable "vpc_id" {
#   description = "VPC in which to deploy the resources"
#   type        = string
# }

variable "alb_target_group_arn" {
  description = "(Optional) ARN of a load balancer target group."
  type = string
}

// To allow users to specify custom tags, we add a new map input variable called custom_tags:
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}
