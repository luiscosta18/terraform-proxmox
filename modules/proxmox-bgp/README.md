# terraform-proxmox/modules/proxmox-bgp

Terraform module scaffold to manage BGP configuration on Proxmox hosts.

This module is intentionally provider-agnostic inside (does not configure providers) so the calling root module supplies provider configuration and credentials.

## Features
- Accepts a list of BGP peers to configure
- Supports a tags map applied to resources
- Example placeholders show where to map to real provider resources

## Usage

```hcl
module "proxmox_bgp" {
  source = "../modules/proxmox-bgp"

  bgp_enabled = true
  bgp_peers = [
    {
      name = "peer-1"
      remote_as = 65001
      remote_addr = "192.0.2.1"
      description = "uplink"
      tags = { environment = "prod" }
    }
  ]

  tags = {
    project = "infrastructure"
    owner   = "netops"
  }
}
```

## Notes & Best practices
- Do not put credentials in module variables. Configure provider authentication in the root module or via environment variables.
- This module currently contains placeholder/null_resource entries so it is safe to review and adapt. When the upstream provider resource names are known (see provider docs), replace the placeholders with real resources and remove the `null_resource` scaffolding.
- Include semantic versioning and changelog for releases.

## Inputs
See variables.tf

## Outputs
See outputs.tf
\n\n
--- VM & Cloud-init (merged) ---
\n
VM and cloud-init support (module notes)

This module now optionally creates VMs using the bpg/proxmox resource `proxmox_virtual_environment_vm`.

How to enable:
- Set module input `create_vms = true` and provide a list of `vms` objects.
- Provide provider configuration in the root module (see examples/simple/providers.tf).

VM object example (detailed disks/networks):

```hcl
vms = [
  {
    name = "web-01"
    vmid = 110
    cores = 2
    memory = 4096
    disks = [
      {
        datastore_id = "local-lvm"
        size_gb = 20
        interface = "scsi0"
        file_format = "qcow2"
      }
    ]
    networks = [
      { bridge = "vmbr0", model = "virtio", tag = 100 }
    ]
    template = "ubuntu-22.04-cloudinit"
    ssh_keys = [file("~/.ssh/id_rsa.pub")]
    user = "ubuntu"
    tags = { role = "web" }
  }
]
```

Notes:
- The module uses `proxmox_virtual_environment_vm` from the bpg/proxmox provider. It supports detailed disk blocks (datastore_id, size_gb, interface, file_format, cache, import_from, file_id, backup) and network_device blocks (bridge, model, hwaddr, tag).
- Keep credentials out of version control: supply via environment variables or CI secrets.
- The cloud-init template `cloudinit.tpl` is included for reference; the provider supports passing `user_account` (keys/password) directly via the `initialization` block.
- This module aims to be declarative and safe: `create_vms` is opt-in. Test in a non-production environment first.
\n\n
--- Tests guidance (merged) ---
\n
Tests and verification

This folder contains guidance and stubs for testing the module. Integration tests require a reachable Proxmox endpoint and credentials. For safe CI, run integration tests only in protected pipelines with secrets.

Suggested tests:
- terraform init & validate using examples/simple
- Create/destroy a small VM in a non-production Proxmox environment
- Verify tags and initialization applied correctly

Local quick checks:
- make fmt
- make validate
