output "kubeconfig" {
  description = "Kubernetes kubeconfig"
  value       = module.talos.kubeconfig
  sensitive   = true
}

output "talosconfig" {
  description = "Talos client configuration"
  value       = module.talos.talosconfig
  sensitive   = true
}
