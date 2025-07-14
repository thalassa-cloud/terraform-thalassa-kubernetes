# Simple Kubernetes Example

This configuration creates a complete Kubernetes cluster infrastructure on Thalassa Cloud, including a VPC with networking components and a Kubernetes cluster with node pools.

## Overview

This example demonstrates how to deploy a production-ready Kubernetes cluster using the Thalassa Cloud Kubernetes module. The configuration includes:

- **VPC Module**: Creates a virtual private cloud with public and private subnets
- **Kubernetes Cluster**: Deploys a Kubernetes control plane with Cilium CNI
- **Node Pools**: Creates worker nodes in the public subnet for application workloads

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Thalassa Cloud                          │
├─────────────────────────────────────────────────────────────┤
│  Region: nl-01                                            │
│  Availability Zones: nl-01a, nl-01b, nl-01c              │
├─────────────────────────────────────────────────────────────┤
│  VPC: kubernetes-example                                  │
│  ├── Public Subnet (10.0.1.0/24)                         │
│  │   └── Worker Nodes (pgp-medium)                       │
│  └── Private Subnet (10.0.2.0/24)                        │
│      └── Control Plane                                    │
├─────────────────────────────────────────────────────────────┤
│  Kubernetes Cluster: v1.32.5-1                            │
│  ├── CNI: Cilium                                         │
│  ├── Control Plane (Private)                              │
│  └── Worker Pool: workers (1 replica)                     │
└─────────────────────────────────────────────────────────────┘
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_thalassa"></a> [thalassa](#requirement\_thalassa) | >= 0.8 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kubernetes"></a> [kubernetes](#module\_kubernetes) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | thalassa-cloud/vpc/thalassa | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Thalassa availability zones | `list(string)` | <pre>[<br/>  "nl-01a",<br/>  "nl-01b",<br/>  "nl-01c"<br/>]</pre> | no |
| <a name="input_organisation_id"></a> [organisation\_id](#input\_organisation\_id) | Thalassa organisation Identity or slug | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Thalassa region | `string` | `"nl-01"` | no |
| <a name="input_thalassa_api"></a> [thalassa\_api](#input\_thalassa\_api) | Thalassa API URL | `string` | n/a | yes |
| <a name="input_thalassa_token"></a> [thalassa\_token](#input\_thalassa\_token) | Thalassa API token | `string` | n/a | yes |

## Outputs

No outputs.

## Usage

### Prerequisites

1. **Thalassa Cloud Account**: Ensure you have an active Thalassa Cloud account
2. **API Token**: Generate an API token from your Thalassa Cloud dashboard
3. **Organisation ID**: Note your organisation ID or slug
4. **Terraform**: Install Terraform >= 1.0

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd terraform-thalassa-kubernetes/examples/simple
   ```

2. **Create a terraform.tfvars file**:
   ```hcl
   thalassa_token     = "your-api-token"
   thalassa_api       = "https://api.thalassa.cloud"
   organisation_id    = "your-organisation-id"
   region            = "nl-01"  # optional, defaults to nl-01
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Plan the deployment**:
   ```bash
   terraform plan
   ```

5. **Apply the configuration**:
   ```bash
   terraform apply
   ```

### Configuration Details

#### VPC Configuration

The VPC module creates a network infrastructure with:

- **Public Subnet**: `10.0.1.0/24` - Hosts worker nodes
- **Private Subnet**: `10.0.2.0/24` - Hosts control plane
- **NAT Gateway**: Enabled for private subnet internet access
- **Labels**: Applied for resource organization

#### Kubernetes Cluster

The cluster is configured with:

- **Version**: `v1.32.5-1` (latest stable)
- **CNI**: Cilium for advanced networking features
- **Control Plane**: Deployed in private subnet for security
- **Labels & Annotations**: Applied for resource management

#### Node Pool Configuration

The worker node pool includes:

- **Machine Type**: `pgp-medium` (balanced performance)
- **Replicas**: 1 (configurable for scaling)
- **Availability Zones**: Multi-zone deployment for high availability
- **Subnet**: Public subnet for direct internet access
- **Auto-scaling**: Configurable for dynamic scaling

### Customization

#### Scaling the Cluster

To scale the worker nodes, modify the `nodepools` configuration:

```hcl
nodepools = {
  "workers" = {
    machine_type       = "pgp-medium"
    availability_zones = var.availability_zones
    replicas           = 3  # Increase for more capacity
    subnet_id          = module.vpc.public_subnet_ids["public"]
    enable_auto_scaling = true
    min_replicas       = 1
    max_replicas       = 10
    # ... other configuration
  }
}
```

#### Adding Multiple Node Pools

You can create multiple node pools for different workloads:

```hcl
nodepools = {
  "workers" = {
    machine_type = "pgp-medium"
    replicas     = 2
    # ... configuration
  }
  "workers2" = {
    machine_type = "pgp-medium"
    replicas     = 1
    node_labels = {
    }
    # ... configuration
  }
}
```

#### Network Customization

Modify the VPC configuration for different network layouts:

```hcl
module "vpc" {
  # ... existing configuration
  
  public_subnets = {
    "public" = {
      "cidr"        = "10.0.1.0/24"
      "description" = "Public subnet"
    }
    "public-secondary" = {
      "cidr"        = "10.0.3.0/24"
      "description" = "Secondary public subnet"
    }
  }

  private_subnets = {
    "private" = {
      "cidr"        = "10.0.2.0/24"
      "description" = "Private subnet"
    }
  }
}
```

### Security Considerations

- **Control Plane**: Deployed in private subnet for enhanced security
- **Worker Nodes**: In public subnet for direct internet access
- **NAT Gateway**: Provides controlled internet access for private resources
- **Labels & Annotations**: Applied for resource organization and security policies

### Monitoring and Management

After deployment, you can:

1. **Access the Cluster**: Use `kubectl` with the cluster credentials
2. **Monitor Resources**: Check the Thalassa Cloud dashboard
3. **Scale Resources**: Modify the Terraform configuration and reapply
4. **Update Versions**: Change `cluster_version` and `kubernetes_version` for upgrades

### Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

**Warning**: This will delete all resources including the Kubernetes cluster and VPC.

## Outputs

This example doesn't define explicit outputs, but you can access the following information:

- **Cluster ID**: Available in the Thalassa Cloud dashboard
- **VPC ID**: `module.vpc.vpc_id`
- **Subnet IDs**: `module.vpc.public_subnet_ids` and `module.vpc.private_subnet_ids`
- **Node Pool IDs**: Available through the nodepool module outputs
