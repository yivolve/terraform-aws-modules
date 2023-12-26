output "query_definition_id" {
  value       = aws_cloudwatch_query_definition.main[*].query_definition_id
  description = "The query definition ID"
}
