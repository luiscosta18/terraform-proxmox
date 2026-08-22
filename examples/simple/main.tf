module "proxmox_bpg" {
  source = "../../modules/proxmox-bpg"

  for_each = local.vm_map

  vm = each.value

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
