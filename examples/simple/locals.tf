locals {
  vm_map = {
    vm01 = {
      name      = "tests"
      node_name = "pve"
      vmid      = 100

      machine = "q35"
      bios    = "seabios"
      os_type = "l26"

      agent_enabled = true

      cores  = 2
      memory = 2048

      storage = "local-lvm"
      disk_gb = 10

      image_datastore_id = "local"

      image_url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

      user     = "ubuntu"
      password = "ubuntu"

      cloud_init = {
        enabled      = false
        datastore_id = "local"
      }

      networks = [
        {
          bridge = "vmbr0"
          model  = "virtio"
        }
      ]
    }
  }
}
