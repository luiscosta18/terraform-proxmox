# Proxmox API keys

This module creates:

- a Proxmox API token for an existing user;
- a Proxmox group;
- a custom Proxmox role with the requested privileges;
- an ACL granting a role to that group.

The token uses the owner's group permissions by default. The token owner must
already exist and be a member of the created group in Proxmox. This module
does not manage user membership.

## Example

```hcl
module "automation_api_key" {
  source = "../../modules/api_keys"

  api_key = {
    user_id     = "terraform@pve"
    token_name  = "automation"
    comment     = "Terraform automation"
  }

  group = {
    group_id = "terraform-automation"
    comment  = "Terraform automation permissions"
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
```
