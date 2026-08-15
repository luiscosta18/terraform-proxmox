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

variable "implementation" {
  description = "Which VM resource implementation to use: 'stable' uses proxmox_virtual_environment_vm, 'experimental' uses proxmox_vm (provider experimental)."
  type        = string
  default     = "stable"

  validation {
    condition     = contains(["stable","experimental"], var.implementation)
    error_message = "implementation must be one of: 'stable' or 'experimental'"
  }
}

variable "vms" {
  description = "List of VMs to create using the proxmox provider. Each VM supports detailed disk and network configuration or a simple disk_gb/storage shortcut."
  type = list(object({
    name      = string
    vmid      = optional(number)
    cores     = optional(number)
    memory    = optional(number)
    # simple disk shortcut
    disk_gb   = optional(number)
    storage   = optional(string)
    # detailed disks
    disks = optional(list(object({
      datastore_id = optional(string)
      size_gb = optional(number)
      interface = optional(string)
      file_format = optional(string)
      cache = optional(string)
      import_from = optional(string)
      file_id = optional(string)
      backup = optional(bool)
    })))
    template  = optional(string)
    ssh_keys  = optional(list(string))
    user      = optional(string)
    password  = optional(string)
    # networks: list of maps { bridge = "vmbr0", model = "virtio" }
    networks = optional(list(object({
      bridge = optional(string)
      model = optional(string)
      tag = optional(number)
      hwaddr = optional(string)
    })))
    tags      = optional(map(string))
  }))
  default = []

  validation {
    condition = length(var.vms) == 0 ? true : alltrue([
      for v in var.vms : (
        alltrue([for k in ["environment","service","product","team","region"] : contains(keys(merge(var.tags, lookup(v, "tags", {}))), k)])
        && contains(["stg","int","prd"], lookup(merge(var.tags, lookup(v, "tags", {})), "environment"))
      )
    ])
    error_message = "Each VM's tags (merged with module tags) must include keys: environment (one of stg,int,prd), service, product, team, region. Provide tags at module level or per-VM."
  }
}
