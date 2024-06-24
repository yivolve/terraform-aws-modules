variable "instance_name" {
  type        = string
  description = "Name to give to the instance"
}

variable "ami_id" {
  description = "The AMI to run in the cluster"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free tier is allowed: t2.micro | t3.micro."
  }
}

variable "subnet_id" {
  type        = string
  description = "(Optional string) VPC Subnet ID to launch in."
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "(Optional list(string), VPC only) List of security group IDs to associate with."
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot time"
  type        = string
  default     = null
}

variable "aws_policy_names" {
  type = list(string)
}

variable "custom_tags" {
  description = "Tags to assign to the created resources"
  type        = map(string)
}
