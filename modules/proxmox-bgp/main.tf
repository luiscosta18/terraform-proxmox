terraform {
  required_version = ">=1.15"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.111"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.create_vms ? local.vm_map : {}

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
        size_gb      = lookup(each.value, "disk_gb", 10)
        interface    = "scsi0"
        file_format  = "qcow2"
      }
    ]

    content {
      datastore_id = lookup(disk.value, "datastore_id", null)
      size         = lookup(disk.value, "size_gb", 10)
      interface    = lookup(disk.value, "interface", "scsi0")
      file_format  = lookup(disk.value, "file_format", null)

      import_from = lookup(disk.value, "import_from", null)
      file_id     = lookup(disk.value, "file_id", null)

      discard  = lookup(disk.value, "discard", null)
      iothread = lookup(disk.value, "iothread", null)
      ssd      = lookup(disk.value, "ssd", null)
    }
  }

  dynamic "network_device" {
    for_each = lookup(each.value, "networks", [])

    content {
      bridge = lookup(network_device.value, "bridge", "vmbr0")
      model  = lookup(network_device.value, "model", "virtio")

      mac_address = lookup(network_device.value, "mac_address", null)
      vlan_id     = lookup(network_device.value, "vlan_id", null)
    }
  }

  initialization {
    user_account {
      username = lookup(each.value, "user", "ubuntu")
      password = lookup(each.value, "password", null)
      keys     = lookup(each.value, "ssh_keys", [])
    }
  }

  tags = [
    for k, v in merge(
      var.tags,
      lookup(each.value, "tags", {})
    ) : "${k}=${v}"
  ]

  agent {
    enabled = lookup(each.value, "agent_enabled", false)
  }

  lifecycle {
    ignore_changes = [
      initialization
    ]
  }

  provisioner "local-exec" {
    when    = create
    command = "echo Created VM ${each.value.name}"
  }
}
