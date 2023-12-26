variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "ami_id" {
  description = "The AMI to run in the ec2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "role_name" {
  description = "A list of aws managed policies to query so they can be attached to the targeted roles"
  type = list(string)
}

# variable "instance_profile_name" {
#   type = string
# }

variable "aws_service_principal" {
  description = "Service principal that will access the intended service"
  type        = list(string)
}

variable "aws_managed_policies" {
  description = "A list of aws managed policies to query so they can be attached to the targeted roles"
  type        = list(string)
}

variable "custom_tags" {
  description = "Tags to assign to the created resources"
  type        = map(string)
}
