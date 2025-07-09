
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
  default     = "1.33"
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
