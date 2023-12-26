output "ecr_repos_arn" {
  value = zipmap(var.repo_names, module.ecr.*.repository_arn)
}

output "ecr_repos_url" {
  value = zipmap(var.repo_names, module.ecr.*.repository_url)
}
