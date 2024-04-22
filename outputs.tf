output "lambda_function_arn" {
  value       = aws_lambda_function.lambda_action.arn
  description = "ARN of the Lambda function"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.example_table.arn
  description = "ARN of the DynamoDB table"
}