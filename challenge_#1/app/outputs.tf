output "project_id" {
  value       = var.project_id
  description = "The project to run tests against"
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.safer-mysql-db.instance_name
}

output "mysql_conn" {
  value       = module.safer-mysql-db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "mysql_user_pass" {
  value       = module.safer-mysql-db.generated_user_password
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}

