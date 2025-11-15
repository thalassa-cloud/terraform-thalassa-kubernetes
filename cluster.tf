
variable "control_plane_delete_protection" {
  description = "Whether to protect the cluster from deletion. Must be set to false to allow deletion of the cluster."
  type        = bool
  nullable    = true
  default     = false
}

variable "networking_service_cidr" {
  description = "The CIDR for the service network"
  type        = string
  default     = null
  nullable    = true
  validation {
    condition     = try(var.networking_service_cidr == null || can(cidrnetmask(var.networking_service_cidr)), true)
    error_message = "Invalid service CIDR. Must be a valid CIDR notation."
  }
}

variable "networking_pod_cidr" {
  description = "The CIDR for the pod network"
  type        = string
  default     = null
  nullable    = true
  validation {
    condition     = try(var.networking_pod_cidr == null || can(cidrnetmask(var.networking_pod_cidr)), true)
    error_message = "Invalid pod CIDR. Must be a valid CIDR notation."
  }
}

variable "pod_security_standards_profile" {
  description = "The pod security standards profile to use for the cluster"
  type        = string
  default     = null
  nullable    = true
  validation {
    condition     = try(var.pod_security_standards_profile == null || contains(["baseline", "restricted", "privileged"], var.pod_security_standards_profile), true)
    error_message = "Invalid pod security standards profile. Valid values are: baseline, restricted, privileged, or null."
  }
}

# Kubernetes cluster
resource "thalassa_kubernetes_cluster" "this" {
  organisation_id = var.organisation_id
  name            = var.name
  description     = var.description
  labels          = var.labels
  annotations     = var.annotations
  region          = var.region
  networking_cni  = var.cni


  networking_pod_cidr     = var.networking_pod_cidr
  networking_service_cidr = var.networking_service_cidr

  cluster_version = var.cluster_version
  subnet_id       = var.subnet_id

  auto_upgrade_policy  = var.auto_upgrade_policy
  maintenance_day      = var.maintenance_day
  maintenance_start_at = var.maintenance_start_at

  disable_public_endpoint        = var.disable_public_endpoint
  security_group_attachments     = var.control_plane_security_group_ids
  pod_security_standards_profile = var.pod_security_standards_profile

  delete_protection = var.control_plane_delete_protection

  api_server_acls {
    allowed_cidrs = var.api_server_acls
  }
}

output "cluster" {
  value = thalassa_kubernetes_cluster.this
}
