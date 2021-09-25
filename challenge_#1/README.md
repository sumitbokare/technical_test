# 3-Tier Environment Setup

- [ Three tier](#three-tier)
- [Tools And Platfom Used](#tools-and-platfom-used)
- [Cloud Services Used](#cloud-services-used)
- [Setup Instructions](#setup-instructions)
- [Sample Input](#sample-input)
- [Inputs](#inputs)
- [Usage](#usage)
- [Testing](#testing)




## Three tier:
This Terraform code provision the resources in GCP, below are prerequisites for testing this code on Cloud:

* Shared VPC is available and Application will be deployed on project which is using shared VPC
* Terraform is using GCS buckets as a backend for storing configuration


Below Architecture diagram represents the actual resources being created for 3 tier environment:

![alt text](https://github.com/sumitbokare/technical_test/blob/main/challenge_%231/3-tier-webapp-arch.png)




## Tools and Platfom used:

**Cloud Provider** : Google Cloud

**IAC Tool**: Terraform and Terragrunt (Wrapper)



## Cloud Services Used:

 **Application Host:** 
 * Google Compute Engine

 **Database**: 
 * Postgres

 **VPC Network:**
 * Load Balancer
 * Subnets
 * Firewall rules

 **Access and Security:**
 * Identitiy Aware Proxy (SSO)
 * SSL cert (Google Managed)



## Setup Instructions:

This terraform module provisions the 3 tier web application in respective env

## Sample Input

Basic usage of this module is as follows:

```hcl
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

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Envionrment (dev,stg,uat,prd)  | `string` | n/a | yes |
| name | Unique name for suffix | `string` | n/a | yes |
| database_version | Latest Postgres SQL version available | `string` | n/a | yes |
| database_tier | Database instance type depending on utilization | `string` | `db-f1-micro` | yes |
| region | Region where DB instance to be created | `string` | `us-east1` | yes |
| availability_type | Enable HA on database (REGIONAL: HA) | `string` | `ZONAL` | yes |
| disk_type | DB instance disk type | `string` | `PD_HDD` | yes |
| userid | Postgres user id | `string` | `myapp` | yes |
| secret_id | Secret ID created for myapp to pull secrets | `string` | n/a | yes |
| backup_enabled | Postgres Database backup  | `bool` | `false` | yes |
| database_flags | Database override variables | `map` | n/a | yes |
| binary_logging_enabled | Database logging | `bool` | `false` | yes |
| machine_type | Compute Engine type for tool | `string` | n/a | yes |
| disk_size_gb | Disk size to be attaches to compute engine | `string` | n/a | yes |
| image_name | URL where image is located | `string` | n/a | yes |
| source_image | Name of image to be used to create instance | `string` | n/a | yes |
| iap_members | Add access to groups to login through Google IAP (SSO)  | `string` | n/a | yes |
| zone | Zone in which resource should be provisioned | `string` | `us-east1-d` | yes |
| host_project | VPC project ID | `string` | `default` | yes |
| network | VPC network to use | `string` | n/a | yes |
| subnetwork | VPC subnet to use | `string` | n/a |  |
| cidr_range | Desired CIDR block | `string` | n/a |  |
| firewall_rule_name | Firewall name to be created | `string` | n/a | yes |
| port | Load balancer port | `string` | n/a | yes |
| min_replicas | Min number of app instance required | `string` | n/a | yes |
| max_replicas | Max number of app instance required | `string` | n/a |  |
| autoscaling_enabled | Enable auto scaling of app instance | `bool` | `false` | yes |
| deletion_protection | Enable DB instance deletion protection | `bool` | `true` | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Usage

Apply as per normal, i.e. `terragrunt apply`


## Testing

Open web URL in browser and use SSO login


