variable "bgp_enabled" {
  description = "Whether to enable BGP configuration"
  type        = bool
  default     = true
}

variable "bgp_peers" {
  description = "List of BGP peers to configure. Each peer is a map with keys: name, remote_as, remote_addr, description (optional)."
  type = list(object({
    name        = string
    remote_as   = number
    remote_addr = string
    description = optional(string)
    tags        = optional(map(string))
  }))
  default = []
}

variable "tags" {
  description = "Global tags to attach to resources managed by this module"
  type        = map(string)
  default     = {}
}

variable "proxmox_hosts" {
  description = "List of Proxmox host connection maps. Each entry: { endpoint = \"https://proxmox:8006\", username=\"root@pam\", password=\"...\", insecure = true }\nNOTE: credentials should be provided via provider or environment; avoid hard-coding secrets in modules."
  type = list(object({
    endpoint = string
    username = string
    password = string
    insecure = optional(bool)
  }))
  default = []
}

variable "create_vms" {
  description = "Whether to create VMs"
  type        = bool
  default     = false
}

variable "vms" {
  description = "List of VMs to create using the proxmox provider. Each VM: name, vmid (optional), cores, memory, disk_gb, storage, template, ssh_keys (list), user, password, net0"
  type = list(object({
    name      = string
    vmid      = optional(number)
    cores     = optional(number)
    memory    = optional(number)
    disk_gb   = optional(number)
    storage   = optional(string)
    template  = optional(string)
    ssh_keys  = optional(list(string))
    user      = optional(string)
    password  = optional(string)
    net0      = optional(string)
    tags      = optional(map(string))
  }))
  default = []
}
