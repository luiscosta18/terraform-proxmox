# Proxmox VM management API key

This example creates a Proxmox API token, creates a group, creates a custom
role, and assigns that role to the group at `/`. The role allows the token
owner to manage VM lifecycle, disks, and VM configuration properties.

The token user must already exist and must already be a member of the group.
The module does not manage user membership. Because the example uses
`privileges_separation = false`, use a dedicated Proxmox user with no other
privileges; the token inherits that user's permissions.

The provider is pinned to `bpg/proxmox` `~> 0.112.0`.

```bash
terraform init
terraform apply
terraform output -raw api_key_value
```

The token value is only returned when the token is created. Store it securely
and pass it to VM-management Terraform configurations as:

```text
terraform@pve!terraform-vm-management=<token-value>
```
