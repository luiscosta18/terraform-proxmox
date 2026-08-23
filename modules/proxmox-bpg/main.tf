resource "proxmox_download_file" "cloud_image" {
  content_type = "import"

  datastore_id = var.vm.image_datastore_id
  node_name    = var.vm.node_name

  url       = var.vm.image_url
  file_name = "${var.vm.name}.qcow2"

  checksum = var.vm.image_checksum

  checksum_algorithm = (
    var.vm.image_checksum == null
    ? null
    : coalesce(var.vm.image_checksum_algorithm, "sha256")
  )

  overwrite = false
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  count = var.vm.cloud_init.enabled ? 1 : 0

  content_type = "snippets"

  datastore_id = var.vm.cloud_init.datastore_id
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

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm.name
  description = var.vm.description

  node_name = var.vm.node_name
  vm_id     = var.vm.vmid

  tags = [
    for key, value in merge(var.tags, var.vm.tags) :
    "${key}-${value}"
  ]

  machine = var.vm.machine
  bios    = var.vm.bios

  operating_system {
    type = var.vm.operating_system_type
  }

  on_boot    = var.vm.on_boot
  started    = var.vm.started
  protection = var.vm.protection
  acpi       = var.vm.acpi

  agent {
    enabled = var.vm.agent_enabled

    wait_for_ip {
      ipv4 = true
      ipv6 = false
    }
  }

  cpu {
    cores   = var.vm.cores
    sockets = var.vm.sockets
  }

  memory {
    dedicated = var.vm.memory
  }

  disk {
    datastore_id = var.vm.storage

    import_from = proxmox_download_file.cloud_image.id

    interface = "virtio0"

    size = var.vm.disk_gb

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
    for_each = var.vm.cloud_init.enabled ? [1] : []

    content {
      # The cloud-init disk itself lives with the VM disks.
      datastore_id = var.vm.storage

      dynamic "ip_config" {
        for_each = var.vm.networks

        content {
          ipv4 {
            address = ip_config.value.ipv4.address

            gateway = (
              ip_config.value.ipv4.address == "dhcp"
              ? null
              : ip_config.value.ipv4.gateway
            )
          }

          dynamic "ipv6" {
            for_each = (
              ip_config.value.ipv6 == null
              ? []
              : [ip_config.value.ipv6]
            )

            content {
              address = ipv6.value.address
              gateway = ip_config.value.ipv6.gateway
            }
          }
        }
      }

      # Custom cloud-init snippet.
      #
      # Do NOT add user_account here because user_data_file_id
      # and user_account are mutually exclusive.
      user_data_file_id = (
        proxmox_virtual_environment_file.cloud_init[0].id
      )
    }
  }
}
