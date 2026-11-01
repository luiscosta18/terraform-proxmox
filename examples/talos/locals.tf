locals {
  #
  # ==========================================================================
  # Talos cluster
  # ==========================================================================
  #

  talos_cluster = {
    name               = "homelab"
    talos_version      = "v1.14.5"
    kubernetes_version = "1.37.2"

    #
    # Reserved Layer-2 VIP.
    #
    # Must NOT be inside the DHCP pool.
    #

    vip = var.talos_vip

    #
    # Stable Kubernetes/Talos API endpoint.
    #

    endpoint = "https://${var.talos_vip}:6443"
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
    iso_url       = data.talos_image_factory_urls.this.urls.iso_secureboot
    installer_url = data.talos_image_factory_urls.this.urls.installer_secureboot
  }

  talos_machine_config_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeFlannelCNIConfig"
      "$patch"   = "delete"
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeletConfig"
      extraArgs = {
        "rotate-server-certificates" = "true"
      }
    }),
  ]

  talos_controlplane_config_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeProxyConfig"
      enabled    = false
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeTalosAPIAccessConfig"
      allowedRoles = [
        "os:etcd:backup",
      ]
      allowedKubernetesNamespaces = [
        "talos-backup",
      ]
    }),
  ]

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
    cores              = 4
    memory             = 8192
    disk_size          = 40
    longhorn_disk_size = 40
  }

  #
  # ==========================================================================
  # Worker defaults
  # ==========================================================================
  #

  talos_worker_defaults = {
    cores     = 4
    memory    = 8192
    disk_size = 40
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

      cores              = local.talos_controlplane_defaults.cores
      memory             = local.talos_controlplane_defaults.memory
      disk_size          = local.talos_controlplane_defaults.disk_size
      longhorn_disk_size = local.talos_controlplane_defaults.longhorn_disk_size

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

      mac_address = null

      labels = {
        nodegroup = "general"
      }

      longhorn_disk_size = 40
    }
  }
}
