# Output values that might be useful in other modules
output "db_host" {
    description = "Database host"
    value       = var.db_host
}

output "db_name" {
    description = "Database name"
    value       = var.db_name
}

output "liquibase_status" {
    description = "Liquibase execution status"
    value       = "Successfully applied database schema"
    depends_on  = [null_resource.liquibase_update]
}