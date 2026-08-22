module "proxmox_bgp" {
  source = "/home/lcosta/work/terraform-proxmox/modules/proxmox-bgp"

  for_each = local.vm_map

  vm = each.value

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
