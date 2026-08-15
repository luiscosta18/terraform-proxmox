# VM creation using bpg/proxmox resource proxmox_virtual_environment_vm
# This resource block will be created only if create_vms = true

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.create_vms ? { for v in var.vms : v.name => v } : {}

  name      = each.value.name
  node_name = lookup(each.value, "node_name", null)
  vm_id     = lookup(each.value, "vmid", null)

  # CPU & memory
  cpu {
    cores = lookup(each.value, "cores", 1)
    # type can be set via nested map in future
  }

  memory {
    dedicated = lookup(each.value, "memory", 2048)
    floating  = lookup(each.value, "memory", 2048)
  }

  # Disks: prefer detailed disks list, fallback to simple disk_gb+storage
  dynamic "disk" {
    for_each = length(lookup(each.value, "disks", [])) > 0 ? lookup(each.value, "disks", []) : [
      {
        datastore_id = lookup(each.value, "storage", "local-lvm")
        size_gb = lookup(each.value, "disk_gb", 10)
        interface = "scsi0"
        file_format = "qcow2"
      }
    ]

    content {
      datastore_id   = lookup(disk.value, "datastore_id", null)
      size           = tostring(lookup(disk.value, "size_gb", 10))
      interface      = lookup(disk.value, "interface", "scsi0")
      file_format    = lookup(disk.value, "file_format", null)
      cache          = lookup(disk.value, "cache", null)
      import_from    = lookup(disk.value, "import_from", null)
      file_id        = lookup(disk.value, "file_id", null)
      backup         = lookup(disk.value, "backup", null)
    }
  }

  # Network devices
  dynamic "network_device" {
    for_each = lookup(each.value, "networks", [])
    content {
      bridge = lookup(network_device.value, "bridge", "vmbr0")
      model  = lookup(network_device.value, "model", "virtio")
      hwaddr = lookup(network_device.value, "hwaddr", null)
      tag    = lookup(network_device.value, "tag", null)
    }
  }

  # Initialization (cloud-init)
  initialization {
    user_account {
      username = lookup(each.value, "user", "ubuntu")
      password = lookup(each.value, "password", null)
      keys     = lookup(each.value, "ssh_keys", [])
    }
    # Optionally pass user_data_file_id from a created file resource
    # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  # Tags
  tags = lookup(each.value, "tags", [])

  # Agent settings
  agent {
    enabled = lookup(each.value, "agent_enabled", false)
  }

  lifecycle {
    ignore_changes = [initialization]
  }

  provisioner "local-exec" {
    when = "create"
    command = "echo Created VM ${each.value.name}"
  }
}
