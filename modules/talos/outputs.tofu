# ==========================================================================
# Control-plane IPs
# ==========================================================================
#

output "controlplane_ips" {
  description = "IPv4 addresses of the Talos control-plane nodes."

  value = {
    for name, vm in proxmox_virtual_environment_vm.controlplane :
    name => vm.ipv4_addresses
  }
}

#
# ==========================================================================
# Worker IPs
# ==========================================================================
#

output "worker_ips" {
  description = "IPv4 addresses of the Talos worker nodes."

  value = {
    for name, vm in proxmox_virtual_environment_vm.worker :
    name => vm.ipv4_addresses
  }
}

#
# ==========================================================================
# All node IPs
# ==========================================================================
#

output "node_ips" {
  description = "IPv4 addresses of all Talos nodes."

  value = concat(
    flatten([
      for vm in values(proxmox_virtual_environment_vm.controlplane) :
      vm.ipv4_addresses
    ]),
    flatten([
      for vm in values(proxmox_virtual_environment_vm.worker) :
      vm.ipv4_addresses
    ])
  )
}

#
# ==========================================================================
# VM IDs
# ==========================================================================
#

output "controlplane_vmids" {
  description = "Proxmox VM IDs of the control-plane nodes."

  value = {
    for name, vm in proxmox_virtual_environment_vm.controlplane :
    name => vm.vm_id
  }
}

output "worker_vmids" {
  description = "Proxmox VM IDs of the worker nodes."

  value = {
    for name, vm in proxmox_virtual_environment_vm.worker :
    name => vm.vm_id
  }
}

#
# ==========================================================================
# Talos client configuration
# ==========================================================================
#

output "talosconfig" {
  description = "Talos client configuration."

  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

#
# ==========================================================================
# Kubernetes kubeconfig
# ==========================================================================
#

output "kubeconfig" {
  description = "Kubernetes kubeconfig."

  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
