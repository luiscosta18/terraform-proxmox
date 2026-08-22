terraform {
  required_version = ">= 1.15"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.111"
    }
  }
}

resource "proxmox_download_file" "cloud_image" {
  content_type = "import"
  datastore_id = var.vm.image_datastore_id
  node_name    = var.vm.node_name

  url = var.vm.image_url

  file_name = format(
    "%s.qcow2",
    var.vm.name
  )
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = try(var.vm.cloud_init.enabled, false) ? { enabled = true } : {}

  content_type = "snippets"
  datastore_id = try(var.vm.cloud_init.datastore_id, "local")
  node_name    = var.vm.node_name

  source_raw {
    file_name = format(
      "%s-cloud-init.yaml",
      var.vm.name
    )

    data = templatefile(
      format(
        "%s/cloudinit.tpl",
        path.module
      ),
      {
        hostname = var.vm.name
        user     = var.vm.user
        password = var.vm.password
      }
    )
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm.name
  node_name = var.vm.node_name
  vm_id     = var.vm.vmid

  machine = var.vm.machine
  bios    = var.vm.bios

  operating_system {
    type = var.vm.os_type
  }

  on_boot = true
  started = true

  acpi          = true
  tablet_device = true

  cpu {
    cores   = var.vm.cores
    sockets = 1
  }

  memory {
    dedicated = var.vm.memory
    floating  = var.vm.memory
  }

  disk {
    datastore_id = var.vm.storage

    import_from = proxmox_download_file.cloud_image.id

    interface = "virtio0"
    size      = var.vm.disk_gb

    iothread = true
    discard  = "on"
  }

  dynamic "network_device" {
    for_each = var.vm.networks

    content {
      bridge      = network_device.value.bridge
      model       = try(network_device.value.model, "virtio")
      mac_address = try(network_device.value.mac_address, null)
      vlan_id     = try(network_device.value.vlan_id, null)
    }
  }

  dynamic "initialization" {
    for_each = try(var.vm.cloud_init.enabled, false) ? { enabled = true } : {}

    content {
      user_data_file_id = proxmox_virtual_environment_file.cloud_init["enabled"].id

      ip_config {
        ipv4 {
          address = "dhcp"
        }
      }
    }
  }

  tags = [
    for k, v in merge(
      try(var.tags, {}),
      try(var.vm.tags, {})
    ) :
    format(
      "%s-%s",
      k,
      v
    )
  ]

  agent {
    enabled = var.vm.agent_enabled
  }

  provisioner "local-exec" {
    when = create

    command = format(
      "echo Created VM %s",
      var.vm.name
    )
  }
}
