resource "google_sql_database_instance" "instance" {
  provider = google-beta
  project  = var.project_id

  deletion_protection = var.deletion_protection

  name             = module.symbol.generic_id
  database_version = var.database_version
  region           = var.region

  settings {
    tier = var.database_tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_subnetwork.myapp_subnet.network
    }

    backup_configuration {
      enabled            = var.backup_enabled
      binary_log_enabled = var.binary_logging_enabled
    }

    availability_type = var.availability_type
    disk_autoresize   = var.fixed_disk_size == null ? true : false
    disk_size         = var.fixed_disk_size
    disk_type         = var.disk_type

    dynamic database_flags {
      for_each = var.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }
  }
}

resource "google_sql_database" "databases" {
  for_each = toset(var.databases)

  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  name     = each.value
}

resource "google_sql_user" "users" {
  for_each = { for user in var.users : user.name => user }

  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  name     = each.key
  password = data.google_secret_manager_secret_version.myapp_secrets.secret_data
}

