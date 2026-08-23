variable "vm" {
  description = "Proxmox virtual machine configuration."

  type = object({
    name        = string
    description = optional(string, "Managed by Terraform")

    node_name = string
    vmid      = optional(number)

    machine = optional(string, "q35")
    bios    = optional(string, "seabios")

    operating_system_type = optional(string, "l26")

    on_boot    = optional(bool, true)
    started    = optional(bool, true)
    protection = optional(bool, false)
    acpi       = optional(bool, true)

    agent_enabled = optional(bool, true)

    cpu = optional(object({
      cores   = optional(number, 2)
      sockets = optional(number, 1)
    }), {})

    memory = optional(number, 4096)

    image = object({
      datastore_id       = string
      url                = string
      checksum           = optional(string)
      checksum_algorithm = optional(string)
    })

    disk = object({
      datastore_id = string
      size         = optional(number, 32)
    })

    networks = list(object({
      bridge      = string
      model       = optional(string, "virtio")
      mac_address = optional(string)
      vlan_id     = optional(number)

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
      enabled              = optional(bool, true)
      datastore_id         = string
      snippet_datastore_id = string

      user     = string
      ssh_keys = list(string)
    })

    tags = optional(map(string), {})
  })
}
