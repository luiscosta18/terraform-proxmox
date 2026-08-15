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
