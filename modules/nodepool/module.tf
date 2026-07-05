
terraform {
  required_version = ">= 1.0"

  required_providers {
    thalassa = {
      version = ">= 0.18"
      source  = "thalassa-cloud/thalassa"
    }
  }
}
