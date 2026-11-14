variable "proxmox_endpoint" {
  description = "Proxmox endpoint URL."

  type = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token."

  type = string
}

variable "talos_vip" {
  description = "Reserved Layer-2 virtual IP for the Talos and Kubernetes API endpoints."

  type = string
}
