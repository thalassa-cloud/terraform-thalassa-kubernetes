# Thalassa Cloud Kubernetes Terraform Module

A Terraform module for provisioning and managing Kubernetes clusters on Thalassa Cloud. This module provides a complete solution for creating production-ready Kubernetes clusters with configurable node pools, networking, and advanced features.

## Features

- **Managed Kubernetes Clusters**: Create and manage Kubernetes clusters with ease
- **Flexible Node Pools**: Configure multiple node pools with different machine types and configurations
- **Multi-AZ Support**: Deploy nodes across multiple availability zones for high availability
- **Auto Healing**: Automatic node replacement for improved reliability
- **Custom Networking**: Support for custom VPC and subnet configurations
- **CNI Options**: Choose between Cilium and custom CNI implementations
- **Node Customization**: Apply custom labels, annotations, and taints to nodes
- **Upgrade Strategies**: Configurable upgrade strategies for node pools
- **Resource Tagging**: labeling and annotation support

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| thalassa  | >= 0.8  |

## Providers

| Name     | Version |
| -------- | ------- |
| thalassa | >= 0.8  |

## Modules

| Name      | Source             | Version |
| --------- | ------------------ | ------- |
| nodepools | ./modules/nodepool | n/a     |

## Resources

| Name                               | Type     |
| ---------------------------------- | -------- |
| thalassa_kubernetes_cluster.this   | resource |
| thalassa_kubernetes_node_pool.this | resource |

## Inputs

### Required

| Name      | Description                                               | Type     | Default   | Required |
| --------- | --------------------------------------------------------- | -------- | --------- | :------: |
| name      | The name of the Kubernetes cluster                        | `string` | n/a       |   yes    |
| region    | The region to create the Kubernetes & Module resources in | `string` | `"nl-01"` |   yes    |
| subnet_id | The ID of the subnet to create the Kubernetes cluster in  | `string` | n/a       |   yes    |

### Optional

| Name            | Description                                                                                                               | Type                 | Default    | Required |
| --------------- | ------------------------------------------------------------------------------------------------------------------------- | -------------------- | ---------- | :------: |
| organisation_id | The ID of the organisation to create the resources in. If not provided, the organisation set in the provider will be used | `string`             | `null`     |    no    |
| description     | The description of the Kubernetes cluster                                                                                 | `string`             | `null`     |    no    |
| labels          | The labels to apply to the module resources                                                                               | `map(string)`        | `{}`       |    no    |
| annotations     | The annotations to apply to the module resources                                                                          | `map(string)`        | `{}`       |    no    |
| cni             | The CNI to use for the Kubernetes cluster                                                                                 | `string`             | `"cilium"` |    no    |
| cluster_version | The version of the Kubernetes cluster                                                                                     | `string`             | `"1.33"`   |    no    |
| vpc_id          | The ID of the VPC to create the Kubernetes cluster in                                                                     | `string`             | n/a        |    no    |
| nodepools       | The nodepools to create for the Kubernetes cluster                                                                        | `map(object({...}))` | `{}`       |    no    |

### Node Pool Configuration

The `nodepools` variable accepts a map of node pool configurations with the following structure:

```hcl
nodepools = {
  "pool-name" = {
    machine_type       = string
    availability_zones = list(string)
    replicas           = optional(number, 1)
    subnet_id          = string

    # Node pool metadata
    labels      = optional(map(string))
    annotations = optional(map(string))

    # Auto scaling
    enable_auto_scaling = optional(bool, false)
    min_replicas        = optional(number)
    max_replicas        = optional(number)

    # Auto healing
    enable_autohealing = optional(bool, false)

    # Versioning
    kubernetes_version = optional(string)
    upgrade_strategy  = optional(string, "always")

    # Node customizations
    node_labels      = optional(map(string))
    node_annotations = optional(map(string))
    node_taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })))
  }
}
```

## Outputs

| Name              | Description                                |
| ----------------- | ------------------------------------------ |
| `cluster_id`      | The ID of the created Kubernetes cluster   |
| `cluster_name`    | The name of the created Kubernetes cluster |
| `cluster_region`  | The region where the cluster is deployed   |
| `cluster_version` | The Kubernetes version of the cluster      |
| `cluster_cni`     | The CNI used by the cluster                |
| `nodepool_ids`    | Map of node pool names to their IDs        |

## Usage

### Basic Example

```hcl
module "kubernetes" {
  source          = "thalassa-cloud/kubernetes/thalassa"
  organisation_id = "your-org-id"
  name            = "my-cluster"
  description     = "Production Kubernetes cluster"
  region          = "nl-01"
  subnet_id       = "subnet-12345"

  labels = {
    environment = "production"
    team        = "platform"
  }
}
```

### Advanced Example with Node Pools

```hcl
module "kubernetes" {
  source          = "thalassa-cloud/kubernetes/thalassa"
  organisation_id = "your-org-id"
  name            = "production-cluster"
  description     = "Production Kubernetes cluster with multiple node pools"
  region          = "nl-01"
  subnet_id       = module.vpc.private_subnet_ids["private"]

  labels = {
    environment = "production"
    team        = "platform"
  }

  nodepools = {
    "system" = {
      machine_type       = "pgp-large"
      availability_zones = ["nl-01a", "nl-01b"]
      replicas           = 2
      subnet_id          = module.vpc.private_subnet_ids["private"]
      enable_autohealing = true
      labels = {
        node-pool = "system"
      }
    }

    "workers" = {
      machine_type       = "pgp-medium"
      availability_zones = ["nl-01a", "nl-01b", "nl-01c"]
      replicas           = 3
      subnet_id          = module.vpc.private_subnet_ids["private"]
      enable_auto_scaling = true
      min_replicas       = 3
      max_replicas       = 10
      enable_autohealing = true
      node_labels = {
        node-pool = "workers"
        workload  = "general"
      }
      node_taints = [
        {
          key    = "workload"
          value  = "general"
          effect = "NoSchedule"
        }
      ]
    }
  }
}
```

## Examples

See the [examples](./examples) directory for complete working examples:

- [Simple Example](./examples/simple): Basic Kubernetes cluster setup with a single node pool

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the MIT License. See the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository or contact the Thalassa Cloud team.
