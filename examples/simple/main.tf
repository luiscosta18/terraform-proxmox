terraform {
  required_version = ">=1.15"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.111"
    }
  }
}

variable "proxmox_endpoint" { type = string }
variable "proxmox_username" { type = string }
variable "proxmox_password" { type = string }
variable "bgp_peers" { type = list(any) }
variable "tags" { type = map(any) }

provider "proxmox" {
  # Configure provider at root level. Prefer using environment variables or a
  # credentials file; avoid hard-coding secrets in versioned code.
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}

module "proxmox_bgp" {
  source = "../../modules/proxmox-bgp"

  bgp_enabled = true
  bgp_peers   = var.bgp_peers
  tags        = var.tags
}
