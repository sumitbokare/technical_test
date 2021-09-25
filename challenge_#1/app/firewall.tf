resource "google_compute_firewall" "myapp_http_lb" {
  project = var.host_project
  name    = var.firewall_rule_name
  network = var.network

  source_tags = ["myapp"]

  allow {
    protocol = "tcp"
    ports    = [
        "80",
        "443",
        "5432"
    ]
  }

}
