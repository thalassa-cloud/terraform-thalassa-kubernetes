
variable "organisation_id" {
  description = "The ID of the organisation to create the resources in. If not provided, the organisation set in the provider will be used."
  type        = string
  nullable    = true
}

variable "name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  nullable    = false
}

variable "description" {
  description = "The description of the Kubernetes cluster"
  type        = string
  nullable    = true
}

variable "region" {
  description = "The region to create the Kubernetes & Module resources in"
  type        = string
  nullable    = false
  default     = "nl-01"
}

variable "labels" {
  description = "The labels to apply to the module resources"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "The annotations to apply to the module resources"
  type        = map(string)
  default     = {}
}

variable "cni" {
  description = "The CNI to use for the Kubernetes cluster"
  type        = string
  default     = "cilium"
  validation {
    condition     = contains(["cilium", "custom"], var.cni)
    error_message = "Invalid CNI. Valid values are: cilium, custom."
  }
}

variable "cluster_version" {
  description = "The version of the Kubernetes cluster"
  type        = string
  default     = null
  validation {
    condition     = try(var.cluster_version == null || can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+-[0-9]+$", var.cluster_version)), true)
    error_message = "Invalid cluster version. Valid values are like: v1.33.4-0, v1.34.1-6."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to create the Kubernetes cluster in"
  type        = string
  nullable    = false
}

variable "subnet_id" {
  description = "The ID of the subnet to create the Kubernetes cluster in"
  type        = string
  nullable    = false
}

variable "api_server_acls" {
  description = "ACL for the API server CIDRs to allow access to the Kubernetes cluster. Leaving empty will allow access from all CIDRs. This is applied on the public API endpoint."
  type        = list(string)
  default     = []

  validation {
    # validate each entry is a valid CIDR
    condition     = alltrue([for cidr in var.api_server_acls : can(cidrnetmask(cidr))])
    error_message = "Invalid CIDR. Each entry must be a valid CIDR notation."
  }
}

variable "disable_public_endpoint" {
  description = "Whether to disable the public endpoint for the Kubernetes cluster. When disabled, the cluster will only be accessible via the private endpoint in the VPC."
  type        = bool
  default     = false
}

variable "control_plane_security_group_ids" {
  description = "The security group IDs to attach to the control plane"
  type        = list(string)
  default     = []
}

variable "maintenance_day" {
  description = "The day of the week to perform maintenance on the Kubernetes cluster. Valid values are: 0-6. Where 0 is Sunday and 6 is Saturday."
  type        = number
  default     = null
  validation {
    condition     = try(var.maintenance_day >= 0 && var.maintenance_day <= 6, true)
    error_message = "Invalid maintenance day. Valid values are: 0-6 or null."
  }
}

variable "maintenance_start_at" {
  description = "The start time to perform maintenance on the Kubernetes cluster. Valid values are: 0-23. Where 0 is 00:00 and 23 is 23:00."
  type        = number
  default     = null
  validation {
    condition     = try(var.maintenance_start_at >= 0 && var.maintenance_start_at <= 23, true)
    error_message = "Invalid maintenance start time. Valid values are: 0-23 or null."
  }
}

variable "auto_upgrade_policy" {
  description = "The auto upgrade policy for the Kubernetes cluster. Valid values are: latest-version, latest-stable, none."
  type        = string
  default     = null
  validation {
    condition     = try(contains(["latest-version", "latest-stable", "none"], var.auto_upgrade_policy), true)
    error_message = "Invalid auto upgrade policy. Valid values are: latest-version, latest-stable, none, or null."
  }
}
