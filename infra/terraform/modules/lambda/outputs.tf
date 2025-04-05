# Outputs
output "function_name" {
    description = "Name of the Lambda function"
    value       = aws_lambda_function.lambda.function_name
}

output "function_arn" {
    description = "ARN of the Lambda function"
    value       = aws_lambda_function.lambda.arn
}

output "role_name" {
    description = "Name of the IAM role for the Lambda function"
    value       = aws_iam_role.lambda_role.name
}

output "role_arn" {
    description = "ARN of the IAM role for the Lambda function"
    value       = aws_iam_role.lambda_role.arn
}