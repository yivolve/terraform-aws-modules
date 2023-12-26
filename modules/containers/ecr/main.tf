locals {
  rules = coalescelist(local.imageCountMoreThan, local.sinceImagePushed)

  imageCountMoreThan = var.count_type == "imageCountMoreThan" ? local.count_type_imageCountMoreThan : null
  sinceImagePushed   = var.count_type == "sinceImagePushed" ? local.count_type_sinceImagePushed : null

  count_type_imageCountMoreThan = [
    {
      rulePriority = 1,
      description  = "Keep the last ${var.number_of_images} images.",
      selection = {
        tagStatus     = var.tag_status,
        tagPrefixList = var.tag_prefix_list,
        countType     = var.count_type,
        countNumber   = var.number_of_images
      },
      action = {
        type = "expire"
      }
    }
  ]

  count_type_sinceImagePushed = [
    {
      rulePriority = 1,
      description  = "Keep the last ${var.number_of_images} images.",
      selection = {
        tagStatus   = var.tag_status,
        countType   = var.count_type,
        countUnit   = "days",
        countNumber = var.number_of_images
      },
      action = {
        type = "expire"
      }
    }
  ]
}

module "ecr" {
  count  = length(var.repo_names)
  source = "terraform-aws-modules/ecr/aws"

  repository_name = var.repo_names[count.index]

  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_read_access_arns       = var.repository_read_access_arns
  repository_lifecycle_policy = jsonencode({
    rules = local.rules
  })

  tags = merge(
    var.custom_tags,
    {
      "Name" : "${var.repo_names[count.index]}"
    }
  )
}
