variable "alb_name" {
  description = "The name to use for this ALB"
  type        = string
}

variable "load_balancer_type" {
  description = "(Optional) The type of load balancer to create. Possible values are application, gateway, or network. The default value is application."
  type        = string
  default     = "application"
}

variable "enable_deletion_protection" {
  description = "(Optional) If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "healthy_threshold" {
  description = "(Optional) Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3."
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "(Optional) Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3."
  type        = number
  default     = 3
}

variable "timeout" {
  description = " (optional) Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. For target groups with a protocol of HTTP, the default is 6 seconds. For target groups with a protocol of TCP, TLS or HTTPS, the default is 10 seconds. For target groups with a protocol of GENEVE, the default is 5 seconds. If the target type is lambda, the default is 30 seconds."
  type        = number
  default     = 6
}

variable "health_check_path" {
  description = "(May be required) Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS. For HTTP and HTTPS health checks, the default is /. For gRPC health checks, the default is /Amazon Web Services.ALB/healthcheck."
  type        = string
}

variable "health_check_port" {
  description = "(Optional) The port the load balancer uses when performing health checks on targets. Valid values are either traffic-port, to use the same port as the target group, or a valid port number between 1 and 65536. Default is traffic-port."
}

variable "interval" {
  description = "(Optional) Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 30."
  type        = number
  default     = 30
}

variable "load_balancing_algorithm" {
  description = "(Optional) Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is round_robin, least_outstanding_requests, or weighted_random. The default is round_robin."
  type = string
  default = "round_robin"
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application or network. For load balancers of type network security groups cannot be added if none are currently present, and cannot all be removed once added. If either of these conditions are met, this will force a recreation of the resource."
  type = list(string)
}

# variable "host_header" {
#   description = "value"
# }

variable "vpc_id" {
  description = "VPC in which to deploy the resources"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "custom_tags" {
  description = "(Optional) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
}
