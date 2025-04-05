# AWS provider configuration
provider "aws" {
    region = var.aws_region
}

# VPC network module
module "vpc" {
    source = "./modules/vpc"
    
    environment          = var.environment
    vpc_cidr             = var.vpc_cidr
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
}

# S3 storage module (images and files)
module "s3_storage" {
    source = "./modules/s3"
    
    bucket_name = var.s3_bucket_name
    environment = var.environment
}

# RDS database module (PostgreSQL)
module "rds_database" {
    source = "./modules/rds"
    
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    environment = var.environment
    vpc_id      = module.vpc.vpc_id
    subnet_ids  = module.vpc.private_subnets
}

# API Gateway to expose Lambda functions
module "api_gateway" {
    source = "./modules/api_gateway"
    
    name        = "castor-service-api"
    environment = var.environment
    
    # Route definitions for Lambdas
    integrations = [
        {
            path         = "/presigned-url"
            http_method  = "POST"
            function_name = module.lambda_presigned_url.function_name
            function_arn  = module.lambda_presigned_url.function_arn
        },
        {
            path         = "/get-file"
            http_method  = "POST"
            function_name = module.lambda_file_retriever.function_name
            function_arn  = module.lambda_file_retriever.function_arn
        }
    ]
    
    # CORS configured for all endpoints
    enable_cors = true
    allowed_origins = ["*"] #TODO: change in production
}

# ECS for the backend (Spring Boot application)
module "ecs_backend" {
    source = "./modules/ecs"
    
    app_name      = "castor-service-backend"
    environment   = var.environment
    vpc_id        = module.vpc.vpc_id
    subnet_ids    = module.vpc.private_subnets
    container_port = 8080
    container_image = var.backend_image
    task_cpu      = "1024"
    task_memory   = "2048"
    desired_count = 2
    
    # Environment variables for the application
    environment_variables = {
        SPRING_PROFILES_ACTIVE = var.environment
        DB_URL                 = module.rds_database.db_endpoint
        DB_NAME                = var.db_name
        DB_USERNAME            = var.db_username
        DB_PASSWORD            = var.db_password
        S3_BUCKET_NAME         = module.s3_storage.bucket_name
        API_GATEWAY_URL        = module.api_gateway.api_endpoint
    }
}

# CloudFront to distribute the frontend
module "cloudfront" {
    source = "./modules/cloudfront"
    
    environment = var.environment
    s3_bucket_id = var.frontend_bucket_id
    s3_bucket_arn = var.frontend_bucket_arn
}