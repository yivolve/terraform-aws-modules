terraform {
  required_version = ">= 1.4.4, < 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.24.0"
    }
  }
}

locals {
  file = yamldecode(file("${path.module}/queries_definition.yaml"))
}
module "insight_queries" {
  source = "../../../../modules/management-and-governance/aws-cloudwatch/insight-queries"

  query = [
    {
      query_name : local.file.dev.query_name,
      log_group_names : local.file.dev.log_group_names,
      query_string : local.file.dev.query_string,
    },
    {
      query_name : local.file.qa.query_name,
      log_group_names : local.file.qa.log_group_names,
      query_string : local.file.dev.query_string, # We use as the query string is the same
    },
  ]
}

output "query_definition_id" {
  value       = module.insight_queries[*].query_definition_id
  description = "The query definition ID."
}
