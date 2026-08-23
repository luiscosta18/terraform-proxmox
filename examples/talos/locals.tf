locals {
  #
  # ==========================================================================
  # Talos cluster
  # ==========================================================================
  #

  talos_cluster = {
    name               = "homelab"
    talos_version      = "v1.13.9"
    kubernetes_version = "1.34.0"

    #
    # Kubernetes/Talos API VIP.
    #

    vip = ""

    endpoint = "https://:6443"
  }

  #
  # ==========================================================================
  # Network
  # ==========================================================================
  #

  talos_network = {
    cidr    = "/24"
    gateway = ""
    vip     = local.talos_cluster.vip

    #
    # Talos interface inside the VM.
    #
    # With the current Proxmox virtio NIC this is normally eth0.
    #

    interface = "eth0"
  }

  #
  # ==========================================================================
  # Proxmox
  # ==========================================================================
  #

  talos_proxmox = {
    image_datastore = "local"
    disk_datastore  = "local-lvm"
    network_bridge  = "vmbr0"
  }

  #
  # ==========================================================================
  # Talos Image Factory
  # ==========================================================================
  #

  talos_image = {
    iso_url = var.talos_iso_url

    checksum = var.talos_iso_checksum

    checksum_algorithm = (
      var.talos_iso_checksum != null
      ? "sha512"
      : null
    )

    installer_url = format(
      "factory.talos.dev/metal-installer/%s:%s",
      var.talos_schematic_id,
      local.talos_cluster.talos_version
    )
  }

  #
  # ==========================================================================
  # Node counts
  # ==========================================================================
  #

  talos_controlplane_count = 3
  talos_worker_count       = 2

  #
  # ==========================================================================
  # Control-plane defaults
  # ==========================================================================
  #

  talos_controlplane_defaults = {
    cores     = 4
    memory    = 8192
    disk_size = 100
  }

  #
  # ==========================================================================
  # Worker defaults
  # ==========================================================================

  talos_worker_defaults = {
    cores     = 4
    memory    = 8192
    disk_size = 100
  }

  #
  # ==========================================================================
  # Proxmox nodes
  # ==========================================================================
  #

  talos_proxmox_nodes = [
    "pve",
  ]

  #
  # ==========================================================================
  # Control-plane VMs
  # ==========================================================================
  #

  talos_controlplanes = {
    for index in range(local.talos_controlplane_count) :
    format("%02d", index + 1) => {
      vmid = 500 + index

      node_name = local.talos_proxmox_nodes[
        index % length(local.talos_proxmox_nodes)
      ]

      cores     = local.talos_controlplane_defaults.cores
      memory    = local.talos_controlplane_defaults.memory
      disk_size = local.talos_controlplane_defaults.disk_size

      #
      # DHCP.
      #
      # QEMU guest agent discovers the real IP.
      #

      mac_address = null

      labels = {
        "node-role.kubernetes.io/control-plane" = ""
      }
    }
  }

  #
  # ==========================================================================
  # Worker VMs
  # ==========================================================================
  #

  talos_workers = {
    for index in range(local.talos_worker_count) :
    format("%02d", index + 1) => {
      vmid = 510 + index

      node_name = local.talos_proxmox_nodes[
        index % length(local.talos_proxmox_nodes)
      ]

      cores     = local.talos_worker_defaults.cores
      memory    = local.talos_worker_defaults.memory
      disk_size = local.talos_worker_defaults.disk_size

      #
      # DHCP.
      #

      mac_address = null

      labels = {
        nodegroup = "general"
      }
    }
  }
}
