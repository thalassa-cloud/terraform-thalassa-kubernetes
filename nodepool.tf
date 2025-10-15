variable "nodepools" {
  description = "The nodepools to create for the Kubernetes cluster"
  type = map(object({
    machine_type       = string
    availability_zones = list(string)
    replicas           = optional(number)
    subnet_id          = string

    # node pool metadata
    labels      = optional(map(string))
    annotations = optional(map(string))

    # auto scaling
    enable_autoscaling = optional(bool, false)
    min_replicas        = optional(number)
    max_replicas        = optional(number)

    # auto healing
    enable_autohealing = optional(bool, false)

    # versioning
    kubernetes_version = optional(string)
    # upgrade strategy
    upgrade_strategy = optional(string, "always")

    # node customizations
    node_labels      = optional(map(string))
    node_annotations = optional(map(string))
    node_taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })))
  }))
  default = {}
}

module "nodepools" {
  source              = "./modules/nodepool"
  for_each            = var.nodepools
  cluster_id          = thalassa_kubernetes_cluster.this.id
  name                = each.key
  machine_type        = each.value.machine_type
  availability_zones  = each.value.availability_zones
  replicas            = each.value.replicas
  subnet_id           = each.value.subnet_id
  labels              = each.value.labels
  annotations         = each.value.annotations
  enable_autohealing  = each.value.enable_autohealing
  enable_autoscaling  = each.value.enable_autoscaling
  min_replicas        = each.value.min_replicas
  max_replicas        = each.value.max_replicas
  kubernetes_version  = each.value.kubernetes_version
  upgrade_strategy    = each.value.upgrade_strategy
  node_labels         = each.value.node_labels
  node_annotations    = each.value.node_annotations
  node_taints         = each.value.node_taints
}
