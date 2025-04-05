# Outputs
output "api_id" {
    description = "ID of the API Gateway"
    value       = aws_api_gateway_rest_api.api.id
}

output "api_endpoint" {
    description = "Base URL of the API Gateway"
    value       = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

output "stage_name" {
    description = "Stage name of the API Gateway"
    value       = aws_api_gateway_deployment.deployment.stage_name
}