variable "name" {
  type    = string
  default = "test"
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
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
  default = "aws-lb-training"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "(Optional) The IAM Instance Profile to launch the instance with. See Instance Profile below for more details."
}

variable "aws_policy_names" {
  type = list(string)
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number

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
}

variable "desired_capacity" {
  description = "The desired capacity number of EC2 Instances in the ASG"
  type        = number
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

// To allow users to specify custom tags, we add a new map input variable called custom_tags:
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC in which to deploy the resources"
  type        = string
}
