// providers.tf - sample provider forwarding for module
// Best practice: configure providers in the root module and pass them to modules via 'providers' map.
// The block below is intentionally commented out. Uncomment only if you need to declare a provider alias
// inside the module (rare). Prefer configuring Telmate/Telmate provider in the root module (see examples/providers.tf).

/*
provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}

# Example of forwarding an aliased provider from root into the module (in root config):
# module "proxmox_bgp" {
#   source = "../modules/proxmox-bgp"
#   providers = { proxmox = proxmox }
# }
*/
