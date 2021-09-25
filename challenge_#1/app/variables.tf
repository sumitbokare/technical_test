################################
# Network Config
################################

variable "host_project" {
  type        = string
}

variable "network" {
  type        = string  
}

variable "subnetwork" {
  type        = string  
}

variable "vpc_region" {
  type    = string   
}

variable "cidr_range" {
  type    = string   
}

variable "env" {
  type        = string
}

variable "name" {
  type        = string
}

variable "region" {
  type        = string
}

variable "zone" {
  type        = string
}

variable "machine_type" {
  type        = string
}

variable "disk_size_gb" {
  type        = string
}


################################
#Load Balancer Variables
################################

variable "firewall_rule_name" {
  type        = string
  default     = "myapp-http-lb"
}

variable "port" {
  default = "8443"
}

################################
# Instance template
################################

variable "source_image" {
  default     = "myapp-1-22-509"
}

variable "source_image_family" {
  default     = "centos"
}

variable "source_image_project" {
  default     = "myapp-project"
}

variable "min_replicas" {
  default     = "1"
}

variable "max_replicas" {
  default     = "10"
}

variable "autoscaling_enabled" {
  type        = bool
  default     = "false"
}


###################################
# SQL Instance Variables
###################################

variable "deletion_protection" {
  type    = bool
  default = "true"
}

variable "database_tier" {
  type    = string
  default = ""
}

variable "disk_type" {
  type    = string
  default = "PD_HDD"
}

variable "database_version" {
  type    = string
  default = ""
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "backup_enabled" {
  type    = string
  default = "false"
}

variable "binary_logging_enabled" {
  type    = bool
  default = "false"
}

variable "database_flags" {
  type        = map
  default     = {}
}

variable "userid" {
  type    = list
}


###################################
# IAP Access Variables
###################################

variable "secret_id" {
  type    = string
}

variable "iap_members" {
  type    = list
}


