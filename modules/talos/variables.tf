#
# modules/talos/variables.tf
#

variable "controlplanes" {
  description = "Talos control-plane VM inventory."

  type = map(object({
    vmid      = number
    node_name = string

    mac_address = optional(string)

    cores     = optional(number, 2)
    memory    = optional(number, 4096)
    disk_size = optional(number, 32)

    labels = optional(map(string), {})
  }))

  validation {
    condition = (
      length(var.controlplanes) >= 3 &&
      length(var.controlplanes) % 2 == 1
    )

    error_message = "controlplanes must contain an odd number of nodes, with at least 3 nodes."
  }
}

variable "workers" {
  description = "Talos worker VM inventory."

  type = map(object({
    vmid      = number
    node_name = string

    mac_address = optional(string)

    cores     = optional(number, 4)
    memory    = optional(number, 8192)
    disk_size = optional(number, 64)

    labels = optional(map(string), {})
  }))

  default = {}
}

variable "cluster" {
  description = "Talos/Kubernetes cluster configuration."

  type = object({
    name               = string
    endpoint           = string
    talos_version      = string
    kubernetes_version = string
    vip                = string
  })
}

variable "network" {
  description = "Network configuration for the Talos cluster."

  type = object({
    cidr      = string
    gateway   = string
    vip       = string
    interface = optional(string)
  })
}

variable "proxmox" {
  description = "Proxmox storage and network configuration."

  type = object({
    image_datastore = string
    disk_datastore  = string
    network_bridge  = string
  })
}

variable "talos_image" {
  description = "Talos installation image configuration."

  type = object({
    iso_url            = string
    installer_url      = string
    checksum           = optional(string)
    checksum_algorithm = optional(string)
  })
}

variable "machine_config_patches" {
  description = "Talos configuration patches applied to all nodes."

  type    = list(string)
  default = []
}

variable "controlplane_config_patches" {
  description = "Talos configuration patches applied to control-plane nodes."

  type    = list(string)
  default = []
}

variable "worker_config_patches" {
  description = "Talos configuration patches applied to worker nodes."

  type    = list(string)
  default = []
}
