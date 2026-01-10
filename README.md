# Thalassa Cloud Kubernetes Terraform Module

A Terraform module for provisioning and managing Kubernetes clusters on Thalassa Cloud. This module provides a complete solution for creating production-ready Kubernetes clusters with configurable node pools, networking, and advanced features.

## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_thalassa"></a> [thalassa](#requirement\_thalassa) | >= 0.18 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_thalassa"></a> [thalassa](#provider\_thalassa) | 0.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nodepools"></a> [nodepools](#module\_nodepools) | ./modules/nodepool | n/a |

## Resources

| Name | Type |
|------|------|
| [thalassa_kubernetes_cluster.this](https://registry.terraform.io/providers/thalassa-cloud/thalassa/latest/docs/resources/kubernetes_cluster) | resource |
| [thalassa_security_group.cluster](https://registry.terraform.io/providers/thalassa-cloud/thalassa/latest/docs/resources/security_group) | resource |
| [thalassa_security_group.controlplane](https://registry.terraform.io/providers/thalassa-cloud/thalassa/latest/docs/resources/security_group) | resource |
| [thalassa_security_group_egress_rule.cluster](https://registry.terraform.io/providers/thalassa-cloud/thalassa/latest/docs/resources/security_group_egress_rule) | resource |
| [thalassa_security_group_ingress_rule.cluster](https://registry.terraform.io/providers/thalassa-cloud/thalassa/latest/docs/resources/security_group_ingress_rule) | resource |
| [thalassa_security_group_ingress_rule.controlplane](https://registry.terraform.io/providers/thalassa-cloud/thalassa/latest/docs/resources/security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The annotations to apply to the module resources | `map(string)` | `{}` | no |
| <a name="input_api_server_acls"></a> [api\_server\_acls](#input\_api\_server\_acls) | ACL for the API server CIDRs to allow access to the Kubernetes cluster. Leaving empty will allow access from all CIDRs. This is applied on the public API endpoint. | `list(string)` | `[]` | no |
| <a name="input_auto_upgrade_policy"></a> [auto\_upgrade\_policy](#input\_auto\_upgrade\_policy) | The auto upgrade policy for the Kubernetes cluster. Valid values are: latest-version, latest-stable, none. | `string` | `null` | no |
| <a name="input_cluster_egress_rules"></a> [cluster\_egress\_rules](#input\_cluster\_egress\_rules) | List of egress rules for the cluster security group. Each rule must specify name, ip\_version, protocol, priority, remote\_type, and policy. For remote\_type 'address', provide remote\_address. For remote\_type 'securityGroup', provide remote\_security\_group\_identity. | <pre>list(object({<br/>    name                           = string<br/>    ip_version                     = string<br/>    protocol                       = string<br/>    priority                       = number<br/>    remote_type                    = string<br/>    remote_address                 = optional(string)<br/>    remote_security_group_identity = optional(string)<br/>    port_range_min                 = optional(number)<br/>    port_range_max                 = optional(number)<br/>    policy                         = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-icmp",<br/>    "policy": "allow",<br/>    "port_range_max": 1,<br/>    "port_range_min": 1,<br/>    "priority": 110,<br/>    "protocol": "icmp",<br/>    "remote_address": "0.0.0.0/0",<br/>    "remote_type": "address"<br/>  },<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-http",<br/>    "policy": "allow",<br/>    "port_range_max": 80,<br/>    "port_range_min": 80,<br/>    "priority": 102,<br/>    "protocol": "tcp",<br/>    "remote_address": "0.0.0.0/0",<br/>    "remote_type": "address"<br/>  },<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-https",<br/>    "policy": "allow",<br/>    "port_range_max": 443,<br/>    "port_range_min": 443,<br/>    "priority": 103,<br/>    "protocol": "tcp",<br/>    "remote_address": "0.0.0.0/0",<br/>    "remote_type": "address"<br/>  }<br/>]</pre> | no |
| <a name="input_cluster_ingress_rules"></a> [cluster\_ingress\_rules](#input\_cluster\_ingress\_rules) | List of ingress rules for the cluster security group. Each rule must specify name, ip\_version, protocol, priority, remote\_type, and policy. For remote\_type 'address', provide remote\_address. For remote\_type 'securityGroup', provide remote\_security\_group\_identity. | <pre>list(object({<br/>    name                           = string<br/>    ip_version                     = string<br/>    protocol                       = string<br/>    priority                       = number<br/>    remote_type                    = string<br/>    remote_address                 = optional(string)<br/>    remote_security_group_identity = optional(string)<br/>    port_range_min                 = optional(number)<br/>    port_range_max                 = optional(number)<br/>    policy                         = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-node-port-range",<br/>    "policy": "allow",<br/>    "port_range_max": 32767,<br/>    "port_range_min": 30000,<br/>    "priority": 105,<br/>    "protocol": "tcp",<br/>    "remote_address": "0.0.0.0/0",<br/>    "remote_type": "address"<br/>  },<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-node-port-range-udp",<br/>    "policy": "allow",<br/>    "port_range_max": 32767,<br/>    "port_range_min": 30000,<br/>    "priority": 106,<br/>    "protocol": "udp",<br/>    "remote_address": "0.0.0.0/0",<br/>    "remote_type": "address"<br/>  }<br/>]</pre> | no |
| <a name="input_cluster_nodeport_ingress_cidr_block"></a> [cluster\_nodeport\_ingress\_cidr\_block](#input\_cluster\_nodeport\_ingress\_cidr\_block) | The CIDR block of the cluster node port ingress | `string` | `"0.0.0.0/0"` | no |
| <a name="input_cluster_nodeport_ingress_cidr_block_udp"></a> [cluster\_nodeport\_ingress\_cidr\_block\_udp](#input\_cluster\_nodeport\_ingress\_cidr\_block\_udp) | The CIDR block of the cluster node port ingress UDP | `string` | `"0.0.0.0/0"` | no |
| <a name="input_cluster_to_controlplane_egress_rules"></a> [cluster\_to\_controlplane\_egress\_rules](#input\_cluster\_to\_controlplane\_egress\_rules) | List of egress rules for the cluster security group to allow traffic to the control plane security group. The remote\_security\_group\_identity will always be set to the control plane security group ID. | <pre>list(object({<br/>    name           = string<br/>    ip_version     = string<br/>    protocol       = string<br/>    priority       = number<br/>    port_range_min = optional(number)<br/>    port_range_max = optional(number)<br/>    policy         = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-kubeapiserver",<br/>    "policy": "allow",<br/>    "port_range_max": 6443,<br/>    "port_range_min": 6443,<br/>    "priority": 100,<br/>    "protocol": "tcp"<br/>  },<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-konnectivity",<br/>    "policy": "allow",<br/>    "port_range_max": 8132,<br/>    "port_range_min": 8132,<br/>    "priority": 101,<br/>    "protocol": "tcp"<br/>  }<br/>]</pre> | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of the Kubernetes cluster | `string` | `null` | no |
| <a name="input_cni"></a> [cni](#input\_cni) | The CNI to use for the Kubernetes cluster | `string` | `"cilium"` | no |
| <a name="input_control_plane_delete_protection"></a> [control\_plane\_delete\_protection](#input\_control\_plane\_delete\_protection) | Whether to protect the cluster from deletion. Must be set to false to allow deletion of the cluster. | `bool` | `false` | no |
| <a name="input_control_plane_security_group_ids"></a> [control\_plane\_security\_group\_ids](#input\_control\_plane\_security\_group\_ids) | The security group IDs to attach to the control plane | `list(string)` | `[]` | no |
| <a name="input_create_security_groups"></a> [create\_security\_groups](#input\_create\_security\_groups) | Create cluster and control plane security groups with default ingress and egress rules. These are automatically configured to allow access between the cluster and control plane, as well as access to the VPC internal DNS. You can override these defaults by providing your own ingress and egress rules. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_disable_public_endpoint"></a> [disable\_public\_endpoint](#input\_disable\_public\_endpoint) | Whether to disable the public endpoint for the Kubernetes cluster. When disabled, the cluster will only be accessible via the private endpoint in the VPC. | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to apply to the module resources | `map(string)` | `{}` | no |
| <a name="input_maintenance_day"></a> [maintenance\_day](#input\_maintenance\_day) | The day of the week to perform maintenance on the Kubernetes cluster. Valid values are: 0-6. Where 0 is Sunday and 6 is Saturday. | `number` | `null` | no |
| <a name="input_maintenance_start_at"></a> [maintenance\_start\_at](#input\_maintenance\_start\_at) | The start time to perform maintenance on the Kubernetes cluster. Valid values are: 0-23. Where 0 is 00:00 and 23 is 23:00. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_networking_pod_cidr"></a> [networking\_pod\_cidr](#input\_networking\_pod\_cidr) | The CIDR for the pod network | `string` | `null` | no |
| <a name="input_networking_service_cidr"></a> [networking\_service\_cidr](#input\_networking\_service\_cidr) | The CIDR for the service network | `string` | `null` | no |
| <a name="input_nodepools"></a> [nodepools](#input\_nodepools) | The nodepools to create for the Kubernetes cluster | <pre>map(object({<br/>    machine_type       = string<br/>    availability_zones = list(string)<br/>    replicas           = optional(number)<br/>    subnet_id          = string<br/><br/>    # node pool metadata<br/>    labels      = optional(map(string))<br/>    annotations = optional(map(string))<br/><br/>    # auto scaling<br/>    enable_autoscaling = optional(bool, false)<br/>    min_replicas       = optional(number)<br/>    max_replicas       = optional(number)<br/><br/>    # auto healing<br/>    enable_autohealing = optional(bool, false)<br/><br/>    # security group IDs to attach to the nodepool<br/>    security_group_ids = optional(list(string), [])<br/><br/>    # versioning<br/>    kubernetes_version = optional(string)<br/>    # upgrade strategy<br/>    upgrade_strategy = optional(string, "always")<br/><br/>    # node customizations<br/>    node_labels      = optional(map(string))<br/>    node_annotations = optional(map(string))<br/>    node_taints = optional(list(object({<br/>      key      = string<br/>      value    = string<br/>      effect   = string<br/>      operator = optional(string, "Exists")<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_organisation_id"></a> [organisation\_id](#input\_organisation\_id) | The ID of the organisation to create the resources in. If not provided, the organisation set in the provider will be used. | `string` | n/a | yes |
| <a name="input_pod_security_standards_profile"></a> [pod\_security\_standards\_profile](#input\_pod\_security\_standards\_profile) | The pod security standards profile to use for the cluster | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create the Kubernetes & Module resources in | `string` | `"nl-01"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to create the Kubernetes cluster in | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the Kubernetes cluster in | `string` | n/a | yes |
| <a name="input_vpc_internal_dns_egress_rules"></a> [vpc\_internal\_dns\_egress\_rules](#input\_vpc\_internal\_dns\_egress\_rules) | List of egress rules for the cluster security group to allow DNS traffic to VPC internal DNS servers. Each rule must specify name, ip\_version, protocol, priority, remote\_address, and policy. | <pre>list(object({<br/>    name           = string<br/>    ip_version     = string<br/>    protocol       = string<br/>    priority       = number<br/>    remote_address = string<br/>    port_range_min = optional(number)<br/>    port_range_max = optional(number)<br/>    policy         = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "ip_version": "ipv4",<br/>    "name": "allow-dns",<br/>    "policy": "allow",<br/>    "port_range_max": 53,<br/>    "port_range_min": 53,<br/>    "priority": 104,<br/>    "protocol": "udp",<br/>    "remote_address": "172.21.8.123/32"<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | n/a |
| <a name="output_controlplane_security_group_id"></a> [controlplane\_security\_group\_id](#output\_controlplane\_security\_group\_id) | n/a |
| <a name="output_nodepools"></a> [nodepools](#output\_nodepools) | n/a |

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
