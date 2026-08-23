module "proxmox_bpg" {
  source = "../../modules/proxmox-bpg"

  for_each = local.vm_map

  vm = each.value

  tags = {
    managed_by  = "terraform"
    environment = "dev"
  }
}
