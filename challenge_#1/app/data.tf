data "google_compute_subnetwork" "myapp_subnet" {
  project = var.host_project
  name    = var.subnetwork
  region  = var.region
}

data "google_secret_manager_secret_version" "myapp_secrets" {
  provider      = google
  project       = var.project_id
  secret        = "projects/${var.project_id}/secrets/myapp-sql-${var.env}"
}

data "google_secret_manager_secret_version" "secrets" {
  provider      = google
  project       = var.project_id
  secret        = "projects/${var.project_id}/secrets/myapp-sql-${var.env}"
}

data "google_secret_manager_secret_version" "myapp_iap_secrets" {
  provider      = google
  project       = var.project_id
  secret        = "projects/${var.project_id}/secrets/myapp-iap-${var.env}"
}

