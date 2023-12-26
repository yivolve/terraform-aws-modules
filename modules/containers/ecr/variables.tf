variable "repo_names" {
  description = "List of repo names to be created. An ECR repository will be created for passed repo name."
  type        = list(string)
}

variable "repository_read_write_access_arns" {
  description = "List of arns that allow read and write access"
  type        = list(string)
  default     = []
}

variable "repository_read_access_arns" {
  type    = list(string)
  default = []
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "number_of_images" {
  description = "Number of images to retain"
  type        = number
}

variable "tag_status" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type        = string
  validation {
    condition     = var.tag_status != "tagged" || var.tag_status != "untagged" || var.tag_status != "any"
    error_message = "Wrong value for input variable 'tag_status', only 'tagged', 'untagged' and 'any' are accepted values."
  }
}

variable "tag_prefix_list" {
  description = "Only used if you specified tagStatus: tagged. You must specify a comma-separated list of image tag prefixes on which to take action with your lifecycle policy. For example, if your images are tagged as prod, prod1, prod2, and so on, you would use the tag prefix prod to specify all of them. If you specify multiple tags, only the images with all specified tags are selected."
  type        = list(string)
  default     = []
}

variable "count_type" {
  description = "If count_type is set to imageCountMoreThan, you also specify countNumber to create a rule that sets a limit on the number of images that exist in your repository. If count_type is set to sinceImagePushed, you also specify countUnit and countNumber to specify a time limit on the images that exist in your repository."
  type        = string
  validation {
    condition     = var.count_type != "imageCountMoreThan" || var.count_type != "sinceImagePushed"
    error_message = "Wrong value for input variable 'count_type', only 'imageCountMoreThan' and 'sinceImagePushed' are accepted values."
  }
}

variable "custom_tags" {
  description = "Map of custom tags to apply to each ECR repo."
  type        = map(string)
  default     = {}
}
