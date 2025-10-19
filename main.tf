# Kubernetes cluster
resource "thalassa_kubernetes_cluster" "this" {
  organisation_id = var.organisation_id
  name            = var.name
  description     = var.description
  labels          = var.labels
  annotations     = var.annotations
  region          = var.region
  networking_cni  = var.cni
  cluster_version = var.cluster_version
  subnet_id       = var.subnet_id

  auto_upgrade_policy  = var.auto_upgrade_policy
  maintenance_day      = var.maintenance_day
  maintenance_start_at = var.maintenance_start_at

  api_server_acls {
    allowed_cidrs = var.api_server_acls
  }
}

output "cluster" {
  value = thalassa_kubernetes_cluster.this
}
