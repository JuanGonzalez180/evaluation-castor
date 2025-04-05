# General variables
variable "aws_region" {
    description = "AWS region where the infrastructure will be deployed"
    type        = string
    default     = "us-east-1"
}

variable "environment" {
    description = "Deployment environment (dev, stage, prod)"
    type        = string
    default     = "dev"
}

# VPC variables
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets"
    type        = list(string)
    default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# S3 variables
variable "s3_bucket_name" {
    description = "Base name of the S3 bucket"
    type        = string
    default     = "castor-service-files"
}

# RDS variables
variable "db_name" {
    description = "Database name"
    type        = string
    default     = "castordb"
}

variable "db_username" {
    description = "Database username"
    type        = string
    default     = "admin"
}

variable "db_password" {
    description = "Database password"
    type        = string
    sensitive   = true
}

# ECS variables
variable "backend_image" {
    description = "Docker image for the backend"
    type        = string
    default     = "castor-service-backend:latest"
}

# Frontend variables (optional)
variable "frontend_bucket_id" {
    description = "S3 bucket ID for the frontend"
    type        = string
    default     = ""
}

variable "frontend_bucket_arn" {
    description = "S3 bucket ARN for the frontend"
    type        = string
    default     = ""
}