output "api_key_id" {
  description = "Proxmox API token identifier."
  value       = proxmox_user_token.this.id
}

output "api_key_value" {
  description = "Proxmox API token value. It is only available when the token is created."
  sensitive   = true
  value       = proxmox_user_token.this.value
}

output "group_id" {
  description = "Proxmox group identifier."
  value       = proxmox_virtual_environment_group.this.group_id
}

output "permission_id" {
  description = "Proxmox ACL identifier."
  value       = proxmox_acl.this.id
}

output "role_id" {
  description = "Proxmox role identifier."
  value       = proxmox_virtual_environment_role.this.role_id
}
