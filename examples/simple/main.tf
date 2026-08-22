module "proxmox_bgp" {
  source = "../../modules/proxmox-bgp"

  for_each = local.vm_map

  vm = each.value

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
