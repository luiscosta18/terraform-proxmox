output "api_key_id" {
  description = "The created Proxmox API token ID."
  value       = module.api_key.api_key_id
}

output "api_key_value" {
  description = "The created Proxmox API token value. Save it immediately; Proxmox does not show it again."
  sensitive   = true
  value       = module.api_key.api_key_value
}
