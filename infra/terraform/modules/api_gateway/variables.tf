# Variables required for the module
variable "name" {
    description = "Name of the API Gateway"
    type        = string
}

variable "environment" {
    description = "Deployment environment (dev, stage, prod)"
    type        = string
}

variable "integrations" {
    description = "List of Lambda integrations with API Gateway"
    type = list(object({
        path          = string
        http_method   = string
        function_name = string
        function_arn  = string
    }))
}

variable "enable_cors" {
    description = "Enable CORS for all endpoints"
    type        = bool
    default     = true
}

variable "allowed_origins" {
    description = "Allowed origins for CORS"
    type        = list(string)
    default     = ["*"]
}

variable "allowed_methods" {
    description = "Allowed HTTP methods for CORS"
    type        = list(string)
    default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "allowed_headers" {
    description = "Allowed headers for CORS"
    type        = list(string)
    default     = ["Content-Type", "Authorization", "X-Amz-Date", "X-Api-Key", "X-Amz-Security-Token"]
}