# Terraform Proxmox

Terraform modules for provisioning and managing virtual machines on [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment) using the [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest) provider.

## Usage

The main reusable module is available in [`modules/proxmox-bpg`](./modules/proxmox-bpg).

Examples are provided for common use cases:

- [`single_vm`](./examples/single_vm) — provision a single virtual machine
- [`multiple_vm`](./examples/multiple_vm) — provision multiple virtual machines
- [`talos`](./examples/talos) — provision virtual machines for Talos Linux
