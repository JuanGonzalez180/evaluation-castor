# Create API Gateway REST API
resource "aws_api_gateway_rest_api" "api" {
    name        = "${var.name}-${var.environment}"
    description = "API Gateway for ${var.name} in environment ${var.environment}"
    
    endpoint_configuration {
        types = ["REGIONAL"]
    }
    
    tags = {
        Name        = var.name
        Environment = var.environment
    }
}

# Create resources for each route
resource "aws_api_gateway_resource" "resources" {
    count       = length(var.integrations)
    
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = trimsuffix(trimprefix(var.integrations[count.index].path, "/"), "/")
}

# Method for each integration
resource "aws_api_gateway_method" "methods" {
    count         = length(var.integrations)
    
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.resources[count.index].id
    http_method   = var.integrations[count.index].http_method
    authorization_type = "NONE"
}

# OPTIONS method for CORS (if enabled)
resource "aws_api_gateway_method" "options_method" {
    count         = var.enable_cors ? length(var.integrations) : 0
    
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.resources[count.index].id
    http_method   = "OPTIONS"
    authorization_type = "NONE"
}

# Lambda integration for each method
resource "aws_api_gateway_integration" "lambda_integrations" {
    count                   = length(var.integrations)
    
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_resource.resources[count.index].id
    http_method             = aws_api_gateway_method.methods[count.index].http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.integrations[count.index].function_arn}/invocations"
}

# Mock integration for OPTIONS (CORS)
resource "aws_api_gateway_integration" "options_integration" {
    count                   = var.enable_cors ? length(var.integrations) : 0
    
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_resource.resources[count.index].id
    http_method             = aws_api_gateway_method.options_method[count.index].http_method
    type                    = "MOCK"
    
    request_templates = {
        "application/json" = jsonencode({
            statusCode = 200
        })
    }
}

# Method response for OPTIONS (CORS)
resource "aws_api_gateway_method_response" "options_200" {
    count       = var.enable_cors ? length(var.integrations) : 0
    
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.resources[count.index].id
    http_method = aws_api_gateway_method.options_method[count.index].http_method
    status_code = "200"
    
    response_models = {
        "application/json" = "Empty"
    }
    
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin"  = true
    }
}

# Integration response for OPTIONS (CORS)
resource "aws_api_gateway_integration_response" "options_integration_response" {
    count       = var.enable_cors ? length(var.integrations) : 0
    
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.resources[count.index].id
    http_method = aws_api_gateway_method.options_method[count.index].http_method
    status_code = aws_api_gateway_method_response.options_200[count.index].status_code
    
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'${join(",", var.allowed_headers)}'",
        "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.allowed_methods)}'",
        "method.response.header.Access-Control-Allow-Origin"  = "'${join(",", var.allowed_origins)}'"
    }
}

# Permission to invoke Lambda from API Gateway
resource "aws_lambda_permission" "api_gateway" {
    count         = length(var.integrations)
    
    statement_id  = "AllowExecutionFromAPIGateway-${var.integrations[count.index].http_method}-${replace(var.integrations[count.index].path, "/", "-")}"
    action        = "lambda:InvokeFunction"
    function_name = var.integrations[count.index].function_name
    principal     = "apigateway.amazonaws.com"
    
    # The ARN must include the API ID, stage, and method
    source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/${var.integrations[count.index].http_method}${var.integrations[count.index].path}"
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "deployment" {
    depends_on = [
        aws_api_gateway_integration.lambda_integrations,
        aws_api_gateway_integration.options_integration
    ]
    
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name  = var.environment
    
    lifecycle {
        create_before_destroy = true
    }
}

# Get the current region
data "aws_region" "current" {}