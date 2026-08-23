resource "proxmox_download_file" "cloud_image" {
  content_type = "import"

  datastore_id = var.vm.image.datastore_id
  node_name    = var.vm.node_name

  url = var.vm.image.url

  file_name = "${var.vm.name}.qcow2"

  checksum           = var.vm.image.checksum
  checksum_algorithm = var.vm.image.checksum_algorithm

  overwrite = false
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  count = var.vm.cloud_init.enabled ? 1 : 0

  content_type = "snippets"

  datastore_id = var.vm.cloud_init.snippet_datastore_id
  node_name    = var.vm.node_name

  source_raw {
    file_name = "${var.vm.name}-cloud-init.yaml"

    data = templatefile(
      "${path.module}/cloudinit.tpl",
      {
        hostname = var.vm.name
        user     = var.vm.cloud_init.user
        ssh_keys = var.vm.cloud_init.ssh_keys
      }
    )
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.vm.name
  description = var.vm.description

  node_name = var.vm.node_name
  vm_id     = var.vm.vmid

  machine = var.vm.machine
  bios    = var.vm.bios

  operating_system {
    type = var.vm.operating_system_type
  }

  on_boot    = var.vm.on_boot
  started    = var.vm.started
  protection = var.vm.protection
  acpi       = var.vm.acpi

  tags = [
    for key, value in var.vm.tags :
    "${key}-${value}"
  ]

  agent {
    enabled = var.vm.agent_enabled

    wait_for_ip {
      ipv4 = true
      ipv6 = false
    }
  }

  cpu {
    cores   = var.vm.cpu.cores
    sockets = var.vm.cpu.sockets
  }

  memory {
    dedicated = var.vm.memory
  }

  disk {
    datastore_id = var.vm.disk.datastore_id

    import_from = proxmox_download_file.cloud_image.id

    interface = "virtio0"

    size = var.vm.disk.size

    iothread = true
    discard  = "on"
  }

  dynamic "network_device" {
    for_each = var.vm.networks

    content {
      bridge      = network_device.value.bridge
      model       = network_device.value.model
      mac_address = network_device.value.mac_address
      vlan_id     = network_device.value.vlan_id
    }
  }

  dynamic "initialization" {
    for_each = var.vm.cloud_init.enabled ? [true] : []

    content {
      datastore_id = var.vm.cloud_init.datastore_id

      dynamic "ip_config" {
        for_each = var.vm.networks

        content {
          ipv4 {
            address = ip_config.value.ipv4.address
            gateway = ip_config.value.ipv4.gateway
          }

          dynamic "ipv6" {
            for_each = (
              ip_config.value.ipv6 == null
              ? []
              : [ip_config.value.ipv6]
            )

            content {
              address = ipv6.value.address
              gateway = ipv6.value.gateway
            }
          }
        }
      }

      user_data_file_id = proxmox_virtual_environment_file.cloud_init[0].id
    }
  }
}
