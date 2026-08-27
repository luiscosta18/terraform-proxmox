variable "proxmox_endpoint" {
  description = "Proxmox endpoint URL."

  type = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token."

  type = string
}

variable "ssh_public_key" {
  description = "SSH public key to provision on the VM."
  type        = string
  sensitive   = true
}
