variable "name" {
  description = "Name of the security group"
  type = string
  default = "aws_lb_training"
}

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID. Defaults to the region's default VPC."
}

variable "tags" {
  type = map(string)
  default = {
    "project" = "AWS Elastic Load Balancing traning"
  }
}
