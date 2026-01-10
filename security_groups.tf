variable "cluster_nodeport_ingress_cidr_block" {
  description = "The CIDR block of the cluster node port ingress"
  type        = string
  default     = "0.0.0.0/0"
}

variable "cluster_nodeport_ingress_cidr_block_udp" {
  description = "The CIDR block of the cluster node port ingress UDP"
  type        = string
  default     = "0.0.0.0/0"
}

variable "create_security_groups" {
  type        = bool
  default     = true
  description = "Create cluster and control plane security groups with default ingress and egress rules. These are automatically configured to allow access between the cluster and control plane, as well as access to the VPC internal DNS. You can override these defaults by providing your own ingress and egress rules."
}

variable "cluster_to_controlplane_egress_rules" {
  description = "List of egress rules for the cluster security group to allow traffic to the control plane security group. The remote_security_group_identity will always be set to the control plane security group ID."
  type = list(object({
    name           = string
    ip_version     = string
    protocol       = string
    priority       = number
    port_range_min = optional(number)
    port_range_max = optional(number)
    policy         = string
  }))
  default = [
    {
      name           = "allow-kubeapiserver"
      ip_version     = "ipv4"
      protocol       = "tcp"
      priority       = 100
      port_range_min = 6443
      port_range_max = 6443
      policy         = "allow"
    },
    {
      name           = "allow-konnectivity"
      ip_version     = "ipv4"
      protocol       = "tcp"
      priority       = 101
      port_range_min = 8132
      port_range_max = 8132
      policy         = "allow"
    }
  ]
}

variable "vpc_internal_dns_egress_rules" {
  description = "List of egress rules for the cluster security group to allow DNS traffic to VPC internal DNS servers. Each rule must specify name, ip_version, protocol, priority, remote_address, and policy."
  type = list(object({
    name           = string
    ip_version     = string
    protocol       = string
    priority       = number
    remote_address = string
    port_range_min = optional(number)
    port_range_max = optional(number)
    policy         = string
  }))
  default = [
    {
      name           = "allow-dns"
      ip_version     = "ipv4"
      protocol       = "udp"
      priority       = 104
      remote_address = "172.21.8.123/32"
      port_range_min = 53
      port_range_max = 53
      policy         = "allow"
    }
  ]
}

variable "cluster_egress_rules" {
  description = "List of egress rules for the cluster security group. Each rule must specify name, ip_version, protocol, priority, remote_type, and policy. For remote_type 'address', provide remote_address. For remote_type 'securityGroup', provide remote_security_group_identity."
  type = list(object({
    name                           = string
    ip_version                     = string
    protocol                       = string
    priority                       = number
    remote_type                    = string
    remote_address                 = optional(string)
    remote_security_group_identity = optional(string)
    port_range_min                 = optional(number)
    port_range_max                 = optional(number)
    policy                         = string
  }))
  default = [
    {
      name           = "allow-icmp"
      ip_version     = "ipv4"
      protocol       = "icmp"
      priority       = 110
      remote_type    = "address"
      remote_address = "0.0.0.0/0"
      port_range_min = 1
      port_range_max = 1
      policy         = "allow"
    },
    {
      name           = "allow-http"
      ip_version     = "ipv4"
      protocol       = "tcp"
      priority       = 102
      remote_type    = "address"
      remote_address = "0.0.0.0/0"
      port_range_min = 80
      port_range_max = 80
      policy         = "allow"
    },
    {
      name           = "allow-https"
      ip_version     = "ipv4"
      protocol       = "tcp"
      priority       = 103
      remote_type    = "address"
      remote_address = "0.0.0.0/0"
      port_range_min = 443
      port_range_max = 443
      policy         = "allow"
    }
  ]
}

variable "cluster_ingress_rules" {
  description = "List of ingress rules for the cluster security group. Each rule must specify name, ip_version, protocol, priority, remote_type, and policy. For remote_type 'address', provide remote_address. For remote_type 'securityGroup', provide remote_security_group_identity."
  type = list(object({
    name                           = string
    ip_version                     = string
    protocol                       = string
    priority                       = number
    remote_type                    = string
    remote_address                 = optional(string)
    remote_security_group_identity = optional(string)
    port_range_min                 = optional(number)
    port_range_max                 = optional(number)
    policy                         = string
  }))
  default = [
    {
      name           = "allow-node-port-range"
      ip_version     = "ipv4"
      protocol       = "tcp"
      priority       = 105
      remote_type    = "address"
      remote_address = "0.0.0.0/0"
      port_range_min = 30000
      port_range_max = 32767
      policy         = "allow"
    },
    {
      name           = "allow-node-port-range-udp"
      ip_version     = "ipv4"
      protocol       = "udp"
      priority       = 106
      remote_type    = "address"
      remote_address = "0.0.0.0/0"
      port_range_min = 30000
      port_range_max = 32767
      policy         = "allow"
    }
  ]
}


resource "thalassa_security_group" "controlplane" {
  count = (var.create_security_groups) ? 1 : 0

  name                     = format("%s-control-plane", var.name)
  description              = coalesce(var.description, "Security group for ${var.name}")
  vpc_id                   = var.vpc_id
  allow_same_group_traffic = false
}

resource "thalassa_security_group_ingress_rule" "controlplane" {
  count = (var.create_security_groups) ? 1 : 0

  security_group_id = thalassa_security_group.controlplane[0].id

  rule {
    name                           = "allow-kubeapiserver"
    ip_version                     = "ipv4"
    protocol                       = "tcp"
    priority                       = 100
    remote_type                    = "securityGroup"
    remote_security_group_identity = thalassa_security_group.cluster[0].id
    port_range_min                 = 6443
    port_range_max                 = 6443
    policy                         = "allow"
  }

  rule {
    name                           = "allow-konnectivity"
    ip_version                     = "ipv4"
    protocol                       = "tcp"
    priority                       = 101
    remote_type                    = "securityGroup"
    remote_security_group_identity = thalassa_security_group.cluster[0].id
    port_range_min                 = 8132
    port_range_max                 = 8132
    policy                         = "allow"
  }

  rule {
    name                           = "allow-icmp"
    ip_version                     = "ipv4"
    protocol                       = "icmp"
    priority                       = 102
    remote_type                    = "securityGroup"
    remote_security_group_identity = thalassa_security_group.cluster[0].id
    policy                         = "allow"
  }

}

resource "thalassa_security_group" "cluster" {
  count = (var.create_security_groups) ? 1 : 0

  name                     = format("%s-cluster", var.name)
  description              = coalesce(var.description, "Security group for ${var.name} cluster")
  vpc_id                   = var.vpc_id
  allow_same_group_traffic = true
}

resource "thalassa_security_group_egress_rule" "cluster" {
  count      = (var.create_security_groups) ? 1 : 0
  depends_on = [thalassa_security_group.controlplane]

  security_group_id = thalassa_security_group.cluster[0].id

  # Dynamic egress rules from cluster to control plane
  dynamic "rule" {
    for_each = var.cluster_to_controlplane_egress_rules
    content {
      name                           = rule.value.name
      ip_version                     = rule.value.ip_version
      protocol                       = rule.value.protocol
      priority                       = rule.value.priority
      remote_type                    = "securityGroup"
      remote_security_group_identity = thalassa_security_group.controlplane[0].id
      port_range_min                 = try(rule.value.port_range_min, null)
      port_range_max                 = try(rule.value.port_range_max, null)
      policy                         = rule.value.policy
    }
  }

  # Dynamic egress rules for VPC internal DNS
  dynamic "rule" {
    for_each = var.vpc_internal_dns_egress_rules
    content {
      name           = rule.value.name
      ip_version     = rule.value.ip_version
      protocol       = rule.value.protocol
      priority       = rule.value.priority
      remote_type    = "address"
      remote_address = rule.value.remote_address
      port_range_min = try(rule.value.port_range_min, null)
      port_range_max = try(rule.value.port_range_max, null)
      policy         = rule.value.policy
    }
  }

  # Dynamic egress rules from variable
  dynamic "rule" {
    for_each = var.cluster_egress_rules
    content {
      name                           = rule.value.name
      ip_version                     = rule.value.ip_version
      protocol                       = rule.value.protocol
      priority                       = rule.value.priority
      remote_type                    = rule.value.remote_type
      remote_address                 = rule.value.remote_type == "address" ? rule.value.remote_address : null
      remote_security_group_identity = rule.value.remote_type == "securityGroup" ? rule.value.remote_security_group_identity : null
      port_range_min                 = try(rule.value.port_range_min, null)
      port_range_max                 = try(rule.value.port_range_max, null)
      policy                         = rule.value.policy
    }
  }

}


resource "thalassa_security_group_ingress_rule" "cluster" {
  count = (var.create_security_groups) ? 1 : 0

  security_group_id = thalassa_security_group.cluster[0].id
  depends_on        = [thalassa_security_group.controlplane, thalassa_security_group_egress_rule.cluster]

  # Dynamic ingress rules from variable
  dynamic "rule" {
    for_each = var.cluster_ingress_rules
    content {
      name                           = rule.value.name
      ip_version                     = rule.value.ip_version
      protocol                       = rule.value.protocol
      priority                       = rule.value.priority
      remote_type                    = rule.value.remote_type
      remote_address                 = rule.value.remote_type == "address" ? rule.value.remote_address : null
      remote_security_group_identity = rule.value.remote_type == "securityGroup" ? rule.value.remote_security_group_identity : null
      port_range_min                 = try(rule.value.port_range_min, null)
      port_range_max                 = try(rule.value.port_range_max, null)
      policy                         = rule.value.policy
    }
  }
}

output "controlplane_security_group_id" {
  value = (var.create_security_groups) ? thalassa_security_group.controlplane[0].id : null
}
