output "peer_names" {
  description = "List of configured BGP peer names"
  value       = [for p in var.bgp_peers : p.name]
}

output "tags" {
  description = "Tags applied to resources"
  value       = var.tags
}

output "vm_ids" {
  description = "VM IDs created by the module (stable or experimental implementation)
  Note: this concatenates IDs from whichever implementation was used."
  value = concat(
    [for r in proxmox_virtual_environment_vm.vm_stable : r.vm_id],
    [for r in proxmox_vm.vm_experimental : r.vm_id]
  )
}
