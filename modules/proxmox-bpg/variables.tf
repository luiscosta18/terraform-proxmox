variable "tags" {
  description = "Common tags applied to all virtual machines."

  type = map(string)

  default = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "vm" {
  description = "Virtual machine configuration."

  type = object({
    name        = string
    description = optional(string, "Managed by Terraform")

    node_name = string
    vmid      = optional(number)

    machine = optional(string, "q35")
    bios    = optional(string, "seabios")

    operating_system_type = optional(string, "l26")

    cores   = optional(number, 2)
    sockets = optional(number, 1)
    memory  = optional(number, 4096)

    storage = string
    disk_gb = optional(number, 32)

    image_datastore_id = string
    image_url          = string

    image_checksum = optional(string)

    image_checksum_algorithm = optional(string, "sha256")

    on_boot    = optional(bool, true)
    started    = optional(bool, true)
    protection = optional(bool, false)
    acpi       = optional(bool, true)

    agent_enabled = optional(bool, true)

    tags = optional(map(string), {})

    networks = list(object({
      bridge      = string
      model       = optional(string, "virtio")
      mac_address = optional(string)
      vlan_id     = optional(number, 0)

      ipv4 = object({
        address = string
        gateway = optional(string)
      })

      ipv6 = optional(object({
        address = string
        gateway = string
      }))
    }))

    cloud_init = object({
      enabled      = optional(bool, true)
      datastore_id = string

      user     = string
      ssh_keys = list(string)
    })
  })
}
