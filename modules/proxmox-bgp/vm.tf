# VM creation using proxmox_vm_qemu (common provider resource name used by community provider)
# This resource block will be created only if create_vms = true

resource "proxmox_vm_qemu" "vm" {
  for_each = var.create_vms ? { for v in var.vms : v.name => v } : {}

  name   = each.value.name
  vmid   = lookup(each.value, "vmid", null)
  cores  = lookup(each.value, "cores", 2)
  memory = lookup(each.value, "memory", 2048)

  # Disk - use cloudinit disk + main disk
  disk {
    type    = "scsi"
    storage = lookup(each.value, "storage", "local-lvm")
    size    = format("%dg", lookup(each.value, "disk_gb", 10))
    format  = "qcow2"
  }

  # Network
  network {
    model = "virtio"
    bridge = "vmbr0"
    % if each.value.net0 != null
    # Allow passing net0 string like "virtio=XX:XX:XX:XX:XX,bridge=vmbr0"
    % endif
  }

  # Cloud-init / SSH keys
  sshkeys = join("\n", lookup(each.value, "ssh_keys", []))
  ciuser  = lookup(each.value, "user", "ubuntu")
  cipassword = lookup(each.value, "password", null)

  # Optional template (cloud-init ready image) to clone from
  clone = lookup(each.value, "template", null)

  agent = 1

  # Tags as a custom attribute map if provider supports it
  lifecycle {
    ignore_changes = [sshkeys]
  }

  provisioner "local-exec" {
    when = "create"
    command = "echo Created VM ${each.value.name}"
  }
}
