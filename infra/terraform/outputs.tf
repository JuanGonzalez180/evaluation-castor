# Outputs
output "api_gateway_url" {
    description = "URL del API Gateway"
    value       = module.api_gateway.api_endpoint
}

output "backend_url" {
    description = "URL del servicio backend"
    value       = module.ecs_backend.service_url
}

output "database_endpoint" {
    description = "Endpoint de la base de datos"
    value       = module.rds_database.db_endpoint
}

output "s3_bucket_name" {
    description = "Nombre del bucket S3"
    value       = module.s3_storage.bucket_name
}

output "presigned_url_lambda_arn" {
    description = "ARN de la función Lambda de URL prefirmada"
    value       = module.lambda_presigned_url.function_arn
}

output "file_retriever_lambda_arn" {
    description = "ARN de la función Lambda de recuperación de archivos"
    value       = module.lambda_file_retriever.function_arn
}