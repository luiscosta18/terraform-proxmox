locals {
  vm_map = {
    for index in range(var.vm_count) :
    format("%s%02d", var.vm_name_prefix, index + 1) => {
      name = format("%s%02d", var.vm_name_prefix, index + 1)

      description = "Managed by terraform"

      node_name = "pve"

      cpu = {
        cores   = 2
        sockets = 1
      }

      memory = 4096

      machine = "q35"
      bios    = "seabios"

      operating_system_type = "l26"

      image = {
        datastore_id = "local"

        url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      }

      disk = {
        datastore_id = "local-lvm"
        size         = 32
      }

      cloud_init = {
        enabled = true

        datastore_id = "local-lvm"

        snippet_datastore_id = "local"

        user = "ubuntu"

        ssh_public_key = var.ssh_public_key
      }

      networks = [
        {
          bridge = "vmbr0"

          ipv4 = {
            address = "dhcp"
          }
        }
      ]

      tags = {
        role = "server"
      }
    }
  }
}
