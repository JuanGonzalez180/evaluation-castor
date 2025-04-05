# Variables required for the module
variable "lambda_name" {
    description = "Name of the Lambda function without the environment suffix"
    type        = string
}

variable "source_dir" {
    description = "Path to the source directory of the Lambda (relative to the monorepo root)"
    type        = string
}

variable "handler" {
    description = "Handler of the Lambda function"
    type        = string
    default     = "index.handler"
}

variable "runtime" {
    description = "Runtime of the Lambda function"
    type        = string
    default     = "nodejs20.x"
}

variable "environment_variables" {
    description = "Environment variables for the Lambda function"
    type        = map(string)
    default     = {}
}

variable "environment" {
    description = "Deployment environment (dev, stage, prod)"
    type        = string
}

variable "timeout" {
    description = "Timeout of the Lambda function in seconds"
    type        = number
    default     = 30
}

variable "memory_size" {
    description = "Memory allocated to the Lambda function in MB"
    type        = number
    default     = 128
}

variable "additional_policies" {
    description = "ARNs of additional policies to attach to the Lambda role"
    type        = list(string)
    default     = []
}