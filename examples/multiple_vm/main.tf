module "vm" {
  source = "../../modules/vm"

  for_each = local.vm_map

  vm = each.value
}
