terraform {
  required_version = ">= 1.4.4, < 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.24.0"
    }
  }
}

module "ecr" {
  source = "../../../modules/containers/ecr"

  repo_names = [
    "module-test-01",
    "module-test-02",
    "module-test-03",
    "module-test-04",
  ]
  repository_read_write_access_arns = []
  repository_read_access_arns       = []
  number_of_images                  = 30

  tag_status      = "tagged"
  tag_prefix_list = ["v"]
  count_type      = "imageCountMoreThan"

  # if tagged in not used then uncomment the following 2 lines and comment the above tag_status, tag_prefix_list and count_type parameters.
  #   tag_status                        = "untagged" # value "any" is also valid.
  #   count_type                        = "sinceImagePushed"
}
