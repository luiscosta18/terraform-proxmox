module "api_key" {
  source = "../../modules/api_keys"

  api_key = {
    user_id               = var.api_key_user_id
    token_name            = var.api_key_token_name
    comment               = "Terraform VM management API token"
    privileges_separation = false
  }

  group = {
    group_id = var.api_key_group_id
    comment  = "Terraform permissions to manage VMs, disks, and VM properties"
  }

  permission = {
    path      = "/"
    propagate = true
  }

  role = {
    role_id = "terraform-vm-management"

    privileges = [
      "Datastore.AllocateSpace",
      "Datastore.Audit",
      "VM.Allocate",
      "VM.Audit",
      "VM.Clone",
      "VM.Config.CDROM",
      "VM.Config.CPU",
      "VM.Config.Disk",
      "VM.Config.HWType",
      "VM.Config.Memory",
      "VM.Config.Network",
      "VM.Config.Options",
      "VM.Console",
      "VM.GuestAgent.Audit",
      "VM.Migrate",
      "VM.PowerMgmt",
      "VM.Snapshot",
      "VM.Snapshot.Rollback",
    ]
  }
}
