
terraform {
  required_providers {
    thalassa = {
      version = ">= 0.14"
      source  = "thalassa-cloud/thalassa"
    }
  }
}

variable "thalassa_token" {
  type        = string
  description = "Thalassa API token"
  sensitive   = true
}

variable "thalassa_api" {
  type        = string
  description = "Thalassa API URL"
}

variable "organisation_id" {
  type        = string
  description = "Thalassa organisation Identity or slug"
}

variable "region" {
  type        = string
  description = "Thalassa region"
  default     = "nl-01"
}

variable "availability_zones" {
  type        = list(string)
  description = "Thalassa availability zones"
  default     = ["nl-01a", "nl-01b", "nl-01c"]
}

provider "thalassa" {
  token           = var.thalassa_token
  api             = var.thalassa_api
  organisation_id = var.organisation_id
}

module "vpc" {
  source          = "thalassa-cloud/vpc/thalassa"
  organisation_id = var.organisation_id
  name            = "kubernetes-example"
  description     = "VPC for Kubernetes example"
  region          = var.region

  labels = {
    "module" = "vpc"
  }
  # module variables
  enable_nat_gateway = true

  public_subnets = {
    "public" = {
      "cidr"        = "10.0.1.0/24"
      "description" = "Public subnet"
    }
  }

  private_subnets = {
    "private" = {
      "cidr"        = "10.0.2.0/24"
      "description" = "Private subnet"
    }
  }
}

locals {
  environment = "example"

  labels = {
    "module"      = "kubernetes"
    "environment" = local.environment
  }
  annotations = {
    "module"      = "kubernetes"
    "environment" = local.environment
  }
}

module "kubernetes" {
  source          = "../../"
  organisation_id = var.organisation_id
  name            = "kubernetes-example"
  description     = "Kubernetes example for Thalassa Cloud Kubernetes module"
  region          = var.region
  cni             = "cilium"
  labels          = local.labels
  annotations     = local.annotations
  vpc_id          = module.vpc.vpc_id
  # Deploy the Control Plane in the private subnet of the VPC
  subnet_id = module.vpc.private_subnet_ids["private"]

  auto_upgrade_policy  = "latest-stable"
  maintenance_day      = 5
  maintenance_start_at = 20
  # api_server_acls      = ["10.0.0.0/0"]

  nodepools = {
    "workers" = {
      machine_type       = "pgp-medium"
      availability_zones = var.availability_zones
      # replicas           = 0
      enable_autoscaling = true
      min_replicas       = 1
      max_replicas       = 2
      subnet_id          = module.vpc.public_subnet_ids["public"]
      labels = {
        "module" = "nodepool"
      }
      annotations = {
        "module" = "nodepool"
      }
      node_labels = {
        "node-type" = "worker"
      }
      node_annotations = {
        "node-type" = "worker"
      }
      node_taints = [
        {
          key      = "node-type"
          value    = "worker"
          effect   = "NoSchedule"
          operator = "Equal"
        }
      ]
    }
  }
}
