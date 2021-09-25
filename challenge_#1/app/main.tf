## VPC Network Config

resource "google_compute_network" "myapp_network" {
  name                    = var.network
  auto_create_subnetworks = "false"
  project                 = var.host_project
}

resource "google_compute_subnetwork" "myapp_subnetwork" {
  name                     = var.subnetwork
  ip_cidr_range            = var.cidr_range
  network                  = google_compute_network.myapp_network.self_link
  region                   = var.region
  project                  = var.host_project
  private_ip_google_access = true
}


## Load balancer

module "http_lb" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 5.1.1"

  name                 = "${var.name}-${var.env}-http-lb"
  project              = var.project_id
  firewall_projects    = [var.host_project]
  firewall_networks    = [var.network]
  ssl                  = true
  managed_ssl_certificate_domains = ["${var.name}.${var.env}.myorg.com"]
  use_ssl_certificates = false
  target_tags          = ["myapp"]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTPS"
      port                            = var.port
      port_name                       = "myapp-https"
      timeout_sec                     = 600
      enable_cdn                      = false
      custom_request_headers          = null
      security_policy                 = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = var.port
        host                = null
        logging             = null
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = module.myapp_mig_regular.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
         enable               = true  
         
         oauth2_client_id     = jsondecode(data.google_secret_manager_secret_version.myapp_iap_secrets.secret_data)["client_id"]

         oauth2_client_secret = jsondecode(data.google_secret_manager_secret_version.myapp_iap_secrets.secret_data)["client_secret"]       

      }
    }
  }
}


## Google IAP

resource "google_iap_client" "myapp_client" {
  display_name = "My App IAP Client"
  brand        = var.brand
  project      = var.project_id
}


## Create regular instance templates

module "myapp_mig_template" {

  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~> 6.5.0"

  name_prefix          = "${var.name}-${var.env}"
  disk_size_gb         = "100"
  machine_type         = var.machine_type
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  preemptible          = false

  startup_script = templatefile("${path.module}/startup_script.sh", { 
    POSTGRESS_INSTANCE            = "myapp.${var.env}.myorg.gcp"
    POSTGRESS_USER                = "myapp"
    POSTGRESS_PASSWORD            = data.google_secret_manager_secret_version.myapp_secrets.secret_data
    DATABASE_NAME                 = var.name
  })

  tags = ["myapp"]

  metadata = { "RandomUserPassword" = data.google_secret_manager_secret_version.myapp_secrets.secret_data }


  network_interface {
    subnetwork_project = var.host_project
    subnetwork         = var.subnetwork
    region             = var.region
  }

  service_account = {
    email  = google_service_account.myapp-sa.email
    scopes = ["cloud-platform"]
  }
}


## Create Regular managed instance group

module "myapp_mig_regular" {
  source              = "terraform-google-modules/vm/google//modules/mig"
  version             = "~> 6.5.0"

  instance_template   = module.myapp_mig_template.self_link
  hostname            = "${var.name}-${var.env}"
  min_replicas        = var.min_replicas
  min_replicas        = var.max_replicas
  autoscaling_enabled = var.autoscaling_enabled

  project_id = var.project_id
  region     = var.region

  named_ports = [{
      name = "myapp-https",
      port = var.port
  }]
}

