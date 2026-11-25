output "function_name" {
  description = "Name of the Lambda audit writer."
  value       = aws_lambda_function.audit_writer.function_name
}

output "function_arn" {
  description = "ARN of the Lambda audit writer."
  value       = aws_lambda_function.audit_writer.arn
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda audit writer."
  value       = aws_lambda_function.audit_writer.invoke_arn
}

output "qualified_arn" {
  description = "Qualified ARN of the published Lambda version, when publishing is enabled."
  value       = aws_lambda_function.audit_writer.qualified_arn
}

output "log_group_name" {
  description = "CloudWatch log group for the Lambda function."
  value       = aws_cloudwatch_log_group.lambda.name
}

output "execution_role_arn" {
  description = "Execution role ARN assigned to the Lambda function."
  value       = var.execution_role_arn
}