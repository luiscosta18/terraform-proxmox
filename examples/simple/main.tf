locals {
  vm_map = {
    ubuntu01 = {
      name        = "ubuntu01"
      description = "Managed by terraform"

      node_name = "pve"

      cores   = 2
      sockets = 1
      memory  = 4096

      machine = "q35"
      bios    = "seabios"

      operating_system_type = "l26"

      storage = "local-lvm"
      disk_gb = 32

      # Ubuntu cloud image is downloaded here.
      #
      # This datastore needs "Import" enabled.
      image_datastore_id = "local"

      image_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

      cloud_init = {
        enabled = true

        # Cloud-init YAML snippet is stored here.
        #
        # This datastore needs "Snippets" enabled.
        datastore_id = "local"

        user = "ubuntu"

        ssh_keys = [
          trimspace(file("~/.ssh/id_rsa.pub"))
        ]
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


module "proxmox_bpg" {
  source = "../../modules/proxmox-bpg"

  for_each = local.vm_map

  vm = each.value

  tags = {
    managed_by  = "terraform"
    environment = "dev"
  }
}
