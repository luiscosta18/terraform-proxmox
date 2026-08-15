VM and cloud-init support (module notes)

This module now optionally creates VMs using the proxmox provider resource `proxmox_vm_qemu`.

How to enable:
- Set module input `create_vms = true` and provide a list of `vms` objects.
- Provide provider configuration in the root module (see examples/simple/providers.tf).

VM object example:

```hcl
vms = [
  {
    name = "web-01"
    vmid = 110
    cores = 2
    memory = 4096
    disk_gb = 20
    storage = "local-lvm"
    template = "ubuntu-22.04-cloudinit"
    ssh_keys = [file("~/.ssh/id_rsa.pub")]
    user = "ubuntu"
    net0 = "virtio,bridge=vmbr0"
    tags = { role = "web" }
  }
]
```

Notes:
- The module uses `proxmox_vm_qemu`. If your chosen provider exposes different resource names, adapt the resource block.
- Keep credentials out of version control: supply via environment variables or CI secrets.
- The cloud-init template `cloudinit.tpl` is included for reference; the proxmox provider supports passing `sshkeys`, `ciuser`, etc directly.
