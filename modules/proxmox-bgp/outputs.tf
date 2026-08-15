output "peer_names" {
  description = "List of configured BGP peer names"
  value       = [for p in var.bgp_peers : p.name]
}

output "tags" {
  description = "Tags applied to resources"
  value       = var.tags
}
