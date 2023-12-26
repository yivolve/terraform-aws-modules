variable "instance_name" {
  type        = string
  description = "Name to give to the instance"
}

variable "ami_id" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-08d4ac5b634553e16"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free tier is allowed: t2.micro | t3.micro."
  }
}

variable "aws_service_principal" {
  type        = string
  description = "EC2, S3, etc.."
}

variable "aws_policy_names" {
  type = list(string)
}

variable "custom_tags" {
  description = "Tags to assign to the created resources"
  type        = map(string)
}

