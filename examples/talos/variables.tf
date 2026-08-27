variable "talos_schematic_id" {
  description = "Talos Image Factory schematic ID."

  type = string
}

variable "talos_iso_url" {
  description = "Talos Image Factory ISO URL."

  type = string
}

variable "talos_iso_checksum" {
  description = "Optional SHA-512 checksum of the Talos ISO."

  type    = string
  default = null
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint URL."

  type = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token."

  type = string
}
