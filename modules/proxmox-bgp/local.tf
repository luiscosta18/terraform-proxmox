locals {
  vm_map = { for v in var.vms : v.name => v }
  merged_tags = var.tags
}
