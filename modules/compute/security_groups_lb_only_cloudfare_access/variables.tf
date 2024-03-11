variable "name" {
  description = "Name of the security group"
  type        = string
  default     = "aws_lb_training"
}

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID. Defaults to the region's default VPC."
}

variable "cidr_block" {
  type = string
}

variable "ingress_rules" {
  description = "ASG ingress rules"
  type = map(object({
    port = number
  }))
  default = {
    "ssh" = {
      port = 443
    },
    "http" = {
      port = 80
    }
  }
}

variable "tags" {
  type = map(string)
  default = {
    "project" = "AWS Elastic Load Balancing traning"
  }
}
