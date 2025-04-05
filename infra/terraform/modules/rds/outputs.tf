# Output the RDS endpoint
output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.postgres.endpoint
}

output "db_host" {
  description = "The database hostname"
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.postgres.db_name
}

output "db_username" {
  description = "The database master username"
  value       = aws_db_instance.postgres.username
}