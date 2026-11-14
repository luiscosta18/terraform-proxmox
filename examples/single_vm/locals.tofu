locals {
  vm_map = {
    ubuntu01 = {
      name        = "ubuntu01"
      description = "Managed by OpenTofu"

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
        # This datastore needs "Import" enabled.
        datastore_id = "local"
        url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      }

      disk = {
        datastore_id = "local-lvm"
        size         = 32
      }

      cloud_init = {
        enabled = true

        datastore_id         = "local-lvm"
        snippet_datastore_id = "local"

        user = "ubuntu"

        ssh_keys = [var.ssh_public_key]
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
