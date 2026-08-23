#
# modules/talos/main.tf
#

#
# ==========================================================================
# Locals
# ==========================================================================
#

locals {
  #
  # QEMU guest agent returns:
  #
  # [
  #   ["127.0.0.1", "169.254.x.x"],
  #   [],
  #   ...
  #   ["192.168.1.216"],
  #   ["10.244.0.0"]
  # ]
  #
  # Flatten everything and select the first usable IPv4 address.
  #

  controlplane_ips = {
    for name, vm in proxmox_virtual_environment_vm.controlplane :
    name => try(
      [
        for ip in flatten(vm.ipv4_addresses) :
        ip
        if can(cidrhost("${ip}/32", 0))
        && ip != "127.0.0.1"
        && !startswith(ip, "169.254.")
        && !startswith(ip, "10.")
        && ip != var.cluster.vip
      ][0],
      null
    )
  }

  worker_ips = {
    for name, vm in proxmox_virtual_environment_vm.worker :
    name => try(
      [
        for ip in flatten(vm.ipv4_addresses) :
        ip
        if can(cidrhost("${ip}/32", 0))
        && ip != "127.0.0.1"
        && !startswith(ip, "169.254.")
        && !startswith(ip, "10.")
        && ip != var.cluster.vip
      ][0],
      null
    )
  }

  #
  # All real node IPs.
  #

  all_ips = concat(
    values(local.controlplane_ips),
    values(local.worker_ips),
  )

  #
  # First control-plane node.
  #
  # This is a REAL node IP.
  # Never use the VIP for bootstrap.
  #

  bootstrap_controlplane = sort(keys(var.controlplanes))[0]

  bootstrap_node = local.controlplane_ips[
    local.bootstrap_controlplane
  ]

  #
  # Proxmox nodes that host Talos VMs.
  #

  proxmox_nodes = toset(
    concat(
      [
        for node in values(var.controlplanes) :
        node.node_name
      ],
      [
        for node in values(var.workers) :
        node.node_name
      ],
    )
  )
}

#
# ==========================================================================
# Talos machine secrets
# ==========================================================================
#

resource "talos_machine_secrets" "this" {
  talos_version = var.cluster.talos_version
}

#
# ==========================================================================
# Talos ISO
# ==========================================================================
#

resource "proxmox_download_file" "talos_iso" {
  for_each = local.proxmox_nodes

  content_type = "iso"

  node_name    = each.key
  datastore_id = var.proxmox.image_datastore

  url = var.talos_image.iso_url

  checksum           = var.talos_image.checksum
  checksum_algorithm = var.talos_image.checksum_algorithm

  file_name = "talos-${var.cluster.talos_version}-amd64.iso"

  overwrite = true
}

#
# ==========================================================================
# Control-plane VMs
# ==========================================================================
#

resource "proxmox_virtual_environment_vm" "controlplane" {
  for_each = var.controlplanes

  name = "${var.cluster.name}-controlplane-${each.key}"

  node_name = each.value.node_name
  vm_id     = each.value.vmid

  description = "Talos control-plane node ${each.key}"

  machine = "q35"
  bios    = "ovmf"

  started         = true
  stop_on_destroy = true
  on_boot         = true

  #
  # CPU
  #

  cpu {
    cores   = each.value.cores
    sockets = 1
    type    = "host"
  }

  #
  # Memory
  #

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  #
  # EFI
  #

  efi_disk {
    datastore_id = var.proxmox.disk_datastore
    type         = "4m"
  }

  #
  # SCSI
  #

  scsi_hardware = "virtio-scsi-pci"

  #
  # Talos system disk
  #

  disk {
    datastore_id = var.proxmox.disk_datastore
    interface    = "scsi0"

    size = each.value.disk_size

    discard = "on"
  }

  #
  # Talos installation ISO
  #

  cdrom {
    interface = "ide2"

    file_id = proxmox_download_file.talos_iso[
      each.value.node_name
    ].id
  }

  #
  # Boot ISO first.
  #
  # Talos will boot the ISO, then install itself to scsi0.
  #

  boot_order = [
    "ide2",
    "scsi0",
  ]

  #
  # QEMU guest agent.
  #

  agent {
    enabled = true

    wait_for_ip {
      disabled = false
      ipv4     = true
      ipv6     = false
    }
  }

  #
  # Network.
  #
  # DHCP is intentional.
  #

  network_device {
    bridge = var.proxmox.network_bridge
    model  = "virtio"

    mac_address = each.value.mac_address
  }

  operating_system {
    type = "l26"
  }

  tags = [
    "cluster-${var.cluster.name}",
    "os-talos",
    "role-controlplane",
  ]
}

#
# ==========================================================================
# Worker VMs
# ==========================================================================
#

resource "proxmox_virtual_environment_vm" "worker" {
  for_each = var.workers

  name = "${var.cluster.name}-worker-${each.key}"

  node_name = each.value.node_name
  vm_id     = each.value.vmid

  description = "Talos worker node ${each.key}"

  machine = "q35"
  bios    = "ovmf"

  started         = true
  stop_on_destroy = true
  on_boot         = true

  #
  # CPU
  #

  cpu {
    cores   = each.value.cores
    sockets = 1
    type    = "host"
  }

  #
  # Memory
  #

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  #
  # EFI
  #

  efi_disk {
    datastore_id = var.proxmox.disk_datastore
    type         = "4m"
  }

  #
  # SCSI
  #

  scsi_hardware = "virtio-scsi-pci"

  #
  # Talos system disk
  #

  disk {
    datastore_id = var.proxmox.disk_datastore
    interface    = "scsi0"

    size = each.value.disk_size

    discard = "on"
  }

  #
  # Talos installation ISO
  #

  cdrom {
    interface = "ide2"

    file_id = proxmox_download_file.talos_iso[
      each.value.node_name
    ].id
  }

  boot_order = [
    "ide2",
    "scsi0",
  ]

  #
  # QEMU guest agent.
  #

  agent {
    enabled = true

    wait_for_ip {
      disabled = false
      ipv4     = true
      ipv6     = false
    }
  }

  #
  # Network.
  #

  network_device {
    bridge = var.proxmox.network_bridge
    model  = "virtio"

    mac_address = each.value.mac_address
  }

  operating_system {
    type = "l26"
  }

  tags = [
    "cluster-${var.cluster.name}",
    "os-talos",
    "role-worker",
  ]
}

#
# ==========================================================================
# Control-plane machine configuration
# ==========================================================================
#

data "talos_machine_configuration" "controlplane" {
  for_each = var.controlplanes

  cluster_name       = var.cluster.name
  cluster_endpoint   = var.cluster.endpoint
  machine_type       = "controlplane"
  talos_version      = var.cluster.talos_version
  kubernetes_version = var.cluster.kubernetes_version

  machine_secrets = talos_machine_secrets.this.machine_secrets

  config_patches = concat(
    var.machine_config_patches,
    var.controlplane_config_patches,

    [
      yamlencode({
        machine = {
          install = {
            disk  = "/dev/sda"
            image = var.talos_image.installer_url
          }

          #
          # Configure the Kubernetes/Talos API VIP.
          #
          # The VIP is NOT the node IP.
          #

          network = {
            interfaces = [
              {
                interface = var.network.interface

                vip = {
                  ip = var.cluster.vip
                }
              }
            ]
          }

          nodeLabels = each.value.labels
        }
      })
    ]
  )
}

#
# ==========================================================================
# Worker machine configuration
# ==========================================================================
#

data "talos_machine_configuration" "worker" {
  for_each = var.workers

  cluster_name       = var.cluster.name
  cluster_endpoint   = var.cluster.endpoint
  machine_type       = "worker"
  talos_version      = var.cluster.talos_version
  kubernetes_version = var.cluster.kubernetes_version

  machine_secrets = talos_machine_secrets.this.machine_secrets

  config_patches = concat(
    var.machine_config_patches,
    var.worker_config_patches,

    [
      yamlencode({
        machine = {
          install = {
            disk  = "/dev/sda"
            image = var.talos_image.installer_url
          }

          nodeLabels = each.value.labels
        }
      })
    ]
  )
}

#
# ==========================================================================
# Apply control-plane configuration
# ==========================================================================
#

resource "talos_machine_configuration_apply" "controlplane" {
  for_each = var.controlplanes

  #
  # IMPORTANT:
  #
  # node     = actual node IP
  # endpoint = actual node IP
  #
  # NEVER use the VIP here during initial configuration.
  #

  node     = local.controlplane_ips[each.key]
  endpoint = local.controlplane_ips[each.key]

  client_configuration = (
    talos_machine_secrets.this.client_configuration
  )

  machine_configuration_input = (
    data.talos_machine_configuration.controlplane[
      each.key
    ].machine_configuration
  )

  apply_mode = "auto"

  depends_on = [
    proxmox_virtual_environment_vm.controlplane,
  ]
}

#
# ==========================================================================
# Bootstrap
# ==========================================================================
#

resource "talos_machine_bootstrap" "this" {
  #
  # Bootstrap only ONE real control-plane node.
  #

  node     = local.bootstrap_node
  endpoint = local.bootstrap_node

  client_configuration = (
    talos_machine_secrets.this.client_configuration
  )

  depends_on = [
    talos_machine_configuration_apply.controlplane,
  ]
}

#
# ==========================================================================
# Apply worker configuration
# ==========================================================================
#

resource "talos_machine_configuration_apply" "worker" {
  for_each = var.workers

  #
  # Workers are configured directly through their own IP.
  #

  node     = local.worker_ips[each.key]
  endpoint = local.worker_ips[each.key]

  client_configuration = (
    talos_machine_secrets.this.client_configuration
  )

  machine_configuration_input = (
    data.talos_machine_configuration.worker[
      each.key
    ].machine_configuration
  )

  apply_mode = "auto"

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}

#
# ==========================================================================
# Talos client configuration
# ==========================================================================
#

data "talos_client_configuration" "this" {
  cluster_name = var.cluster.name

  client_configuration = (
    talos_machine_secrets.this.client_configuration
  )

  #
  # Real node IPs.
  #

  nodes = local.all_ips

  #
  # Stable Talos/Kubernetes endpoint.
  #

  endpoints = [
    var.cluster.endpoint
  ]

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}

#
# ==========================================================================
# Kubernetes kubeconfig
# ==========================================================================
#

resource "talos_cluster_kubeconfig" "this" {
  #
  # Retrieve kubeconfig through the bootstrap node.
  #

  node = local.bootstrap_node

  endpoint = local.bootstrap_node

  client_configuration = (
    talos_machine_secrets.this.client_configuration
  )

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}
