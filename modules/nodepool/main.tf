variable "name" {
  description = "The name of the nodepool"
  type        = string
  nullable    = false
}

variable "machine_type" {
  description = "The machine type to use for the nodepool"
  type        = string
  nullable    = false
}

variable "availability_zones" {
  description = "The availability zones to use for the nodepool"
  type        = list(string)
  nullable    = false
}

variable "replicas" {
  description = "The number of replicas to use for the nodepool"
  type        = number
  nullable    = false
}

variable "subnet_id" {
  description = "The subnet ID to use for the nodepool"
  type        = string
  nullable    = false
}

variable "labels" {
  description = "The labels to use for the nodepool"
  type        = map(string)
  nullable    = false
}

variable "annotations" {
  description = "The annotations to use for the nodepool"
  type        = map(string)
  nullable    = false
}

variable "enable_autohealing" {
  description = "Whether to enable auto healing for the nodepool"
  type        = bool
  nullable    = false
}

variable "enable_auto_scaling" {
  description = "Whether to enable auto scaling for the nodepool"
  type        = bool
  nullable    = false
}

variable "upgrade_strategy" {
  description = "The upgrade strategy to use for the nodepool"
  type        = string
  nullable    = false
  default     = "always"
}

variable "min_replicas" {
  description = "The minimum number of replicas to use for the nodepool"
  type        = number
  nullable    = false
  default     = 0
}

variable "max_replicas" {
  description = "The maximum number of replicas to use for the nodepool"
  type        = number
  nullable    = false
  default     = 0
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use for the nodepool"
  type        = string
  nullable    = false
}

variable "node_labels" {
  description = "The node labels to use for the nodepool"
  type        = map(string)
  nullable    = true
}

variable "node_annotations" {
  description = "The node annotations to use for the nodepool"
  type        = map(string)
  nullable    = true
}

variable "node_taints" {
  description = "The node taints to use for the nodepool"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  nullable = true
}

variable "cluster_id" {
  description = "The ID of the cluster to create the nodepool in"
  type        = string
  nullable    = false
}

resource "thalassa_kubernetes_node_pool" "this" {
  for_each           = toset(var.availability_zones)
  cluster_id         = var.cluster_id
  name               = var.name
  machine_type       = var.machine_type
  replicas           = var.replicas
  labels             = var.labels
  annotations        = var.annotations
  availability_zone  = each.value
  kubernetes_version = var.kubernetes_version
  subnet_id          = var.subnet_id
  upgrade_strategy   = var.upgrade_strategy

  enable_autohealing = var.enable_autohealing

  #   enable_auto_scaling = each.value.enable_auto_scaling
  #   min_replicas = each.value.min_replicas
  #   max_replicas = each.value.max_replicas

  node_labels      = var.node_labels
  node_annotations = var.node_annotations
  #   node_taints = var.node_taints
}
