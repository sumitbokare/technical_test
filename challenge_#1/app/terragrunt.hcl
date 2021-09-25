include {
  path = find_in_parent_folders()
}

terraform {
  source = "./"
}

inputs = {

# App Env details:

        env                     = "myenv"
        name                    = "myapp"
        region                  = "us-east1"
        zone                    = "us-east1-b"
        machine_type            = "n1-standard-8"
        disk_size_gb            = "50"

# Network Config

        host_project            = "myvpc"
        network                 = "myapp_network"
        subnetwork              = "myapp_subnetwork"
        vpc_region              = "us-east1"
        cidr_range              = "10.60.0.0/16"

# Load Balancer Variables

        firewall_rule_name      = "myapp-http-lb"
        port                    = "8443"

# Instance Templates

        min_replicas            = "2"
        max_replicas            = "10"
        autoscaling_enabled     = true

# SQL Instance Variables

        deletion_protection     = true
        database_tier           = "db-g1-small"
        disk_type               = "PD_HDD"
        database_version        = "POSTGRES_12"
        availability_type       = "ZONAL"
        backup_enabled          = true
        binary_logging_enabled  = true
        database_flags          = []
        userid                  = ["mydbuser"]

# IAP Access Variables

        secret_id               = "myapp-secrets"
        iap_members             = [
                                    "dev@myorg.com",
                                    "admin@myorg.com"
                                ]

    }


