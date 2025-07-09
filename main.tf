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
  # vpc_id          = var.vpc_id
  subnet_id = var.subnet_id
}
