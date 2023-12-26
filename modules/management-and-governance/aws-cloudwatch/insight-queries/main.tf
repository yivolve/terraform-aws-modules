resource "aws_cloudwatch_query_definition" "main" {
  count = length(var.query)
  name  = var.query[count.index].query_name

  log_group_names = var.query[count.index].log_group_names

  query_string = var.query[count.index].query_string
}
