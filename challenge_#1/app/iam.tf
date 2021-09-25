resource "google_service_account" "myapp-sa" {
  account_id   = "myapp-${var.env}-${var.sov}-sa"
  project = var.project_id
  display_name = "Service Account for myapp"
}

resource "google_project_iam_member" "db_iam_binding" {
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = google_service_account.account_id
}

resource "google_iap_web_iam_binding" "myapp_iap_members" {
  project = var.project_id
  role = "roles/iap.httpsResourceAccessor"
  members = var.iap_members
}

