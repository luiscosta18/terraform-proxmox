variable "vm" {

  type = object({
    name      = string
    node_name = string
    vmid      = number

    machine = string
    bios    = string
    os_type = optional(string, "l26")

    agent_enabled = bool

    protection = optional(bool, false)

    cores  = number
    memory = number

    storage            = string
    image_datastore_id = string
    image_url          = string
    disk_gb            = number

    user     = string
    password = string

    cloud_init = object({
      enabled      = bool
      datastore_id = string
    })

    networks = list(object({
      bridge      = string
      model       = optional(string, "virtio")
      mac_address = optional(string)
      vlan_id     = optional(number)
    }))

    tags = optional(map(string), {})
  })
}

variable "tags" {
  description = "Additional VM tags"

  type    = map(string)
  default = {}
}
