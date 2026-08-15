// Module: proxmox-bgp
// This module is a scaffold for configuring BGP on Proxmox using the bpg/proxmox provider.
// IMPORTANT: Do not declare provider blocks inside modules in general; pass provider configuration from root module.

locals {
  merged_tags = var.tags
}

# Example placeholder: loop over peers and create resources. Replace the null_resource with
# the real provider resource (e.g. proxmox_bgp_neighbor or similar) from the upstream provider.

resource "null_resource" "bgp_peer" {
  for_each = var.bgp_enabled ? { for p in var.bgp_peers : p.name => p } : {}

  triggers = {
    name        = each.value.name
    remote_as   = tostring(each.value.remote_as)
    remote_addr = each.value.remote_addr
  }

  provisioner "local-exec" {
    when    = "create"
    command = "echo Configuring BGP peer ${each.value.name} to ${each.value.remote_addr}"
  }
}

# Attach tags as outputs so calling code can reference them
