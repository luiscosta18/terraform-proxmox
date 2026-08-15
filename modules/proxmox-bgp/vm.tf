# Two VM implementations: stable uses proxmox_virtual_environment_vm, experimental uses proxmox_vm

# Stable implementation (recommended)
resource "proxmox_virtual_environment_vm" "vm_stable" {
  for_each = var.create_vms && var.implementation == "stable" ? local.vm_map : {}

  name      = each.value.name
  node_name = lookup(each.value, "node_name", null)
  vm_id     = lookup(each.value, "vmid", null)

  cpu {
    cores = lookup(each.value, "cores", 1)
  }

  memory {
    dedicated = lookup(each.value, "memory", 2048)
    floating  = lookup(each.value, "memory", 2048)
  }

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

  dynamic "network_device" {
    for_each = lookup(each.value, "networks", [])
    content {
      bridge = lookup(network_device.value, "bridge", "vmbr0")
      model  = lookup(network_device.value, "model", "virtio")
      hwaddr = lookup(network_device.value, "hwaddr", null)
      tag    = lookup(network_device.value, "tag", null)
    }
  }

  initialization {
    user_account {
      username = lookup(each.value, "user", "ubuntu")
      password = lookup(each.value, "password", null)
      keys     = lookup(each.value, "ssh_keys", [])
    }
  }

  tags = [for k,v in merge(var.tags, lookup(each.value, "tags", {})) : "${k}=${v}"]

  agent {
    enabled = lookup(each.value, "agent_enabled", false)
  }

  lifecycle {
    ignore_changes = [initialization]
  }

  provisioner "local-exec" {
    when = "create"
    command = "echo Created VM ${each.value.name} (stable)"
  }
}

# Experimental implementation (provider experimental resource)
resource "proxmox_vm" "vm_experimental" {
  for_each = var.create_vms && var.implementation == "experimental" ? local.vm_map : {}

  name      = each.value.name
  node_name = lookup(each.value, "node_name", null)
  vm_id     = lookup(each.value, "vmid", null)

  cpu {
    cores = lookup(each.value, "cores", 1)
  }

  memory {
    dedicated = lookup(each.value, "memory", 2048)
    floating  = lookup(each.value, "memory", 2048)
  }

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

  dynamic "network_device" {
    for_each = lookup(each.value, "networks", [])
    content {
      bridge = lookup(network_device.value, "bridge", "vmbr0")
      model  = lookup(network_device.value, "model", "virtio")
      hwaddr = lookup(network_device.value, "hwaddr", null)
      tag    = lookup(network_device.value, "tag", null)
    }
  }

  initialization {
    user_account {
      username = lookup(each.value, "user", "ubuntu")
      password = lookup(each.value, "password", null)
      keys     = lookup(each.value, "ssh_keys", [])
    }
  }

  tags = [for k,v in merge(var.tags, lookup(each.value, "tags", {})) : "${k}=${v}"]

  agent {
    enabled = lookup(each.value, "agent_enabled", false)
  }

  lifecycle {
    ignore_changes = [initialization]
  }

  provisioner "local-exec" {
    when = "create"
    command = "echo Created VM ${each.value.name} (experimental)"
  }
}
