# Outputs
output "api_gateway_url" {
    description = "API Gateway URL"
    value       = module.api_gateway.api_endpoint
}

output "backend_url" {
    description = "Backend service URL"
    value       = module.ecs_backend.service_url
}

output "database_endpoint" {
    description = "Database endpoint"
    value       = module.rds_database.db_endpoint
}

output "s3_bucket_name" {
    description = "S3 bucket name"
    value       = module.s3_storage.bucket_name
}

output "presigned_url_lambda_arn" {
    description = "ARN of the presigned URL Lambda function"
    value       = module.lambda_presigned_url.function_arn
}

output "file_retriever_lambda_arn" {
    description = "ARN of the file retriever Lambda function"
    value       = module.lambda_file_retriever.function_arn
}