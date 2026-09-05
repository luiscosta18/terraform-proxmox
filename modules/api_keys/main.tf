resource "proxmox_virtual_environment_group" "this" {
  group_id = var.group.group_id
  comment  = var.group.comment
}

resource "proxmox_user_token" "this" {
  user_id    = var.api_key.user_id
  token_name = var.api_key.token_name

  comment               = var.api_key.comment
  expiration_date       = var.api_key.expiration_date
  privileges_separation = var.api_key.privileges_separation
}

resource "proxmox_virtual_environment_role" "this" {
  role_id    = var.role.role_id
  privileges = var.role.privileges
}

resource "proxmox_acl" "this" {
  group_id = proxmox_virtual_environment_group.this.group_id
  path     = var.permission.path
  role_id  = proxmox_virtual_environment_role.this.role_id

  propagate = var.permission.propagate
}
