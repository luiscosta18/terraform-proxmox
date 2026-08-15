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
