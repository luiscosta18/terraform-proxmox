# Terraform Proxmox

Terraform modules for provisioning and managing virtual machines on [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment) using the [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest) provider.

Terraform modules for provisioning, configuring, and managing [Talos Linux](https://www.talos.dev/) Kubernetes clusters using the [siderolabs/talos](https://registry.terraform.io/providers/siderolabs/talos/latest) Terraform provider.

## Usage

Examples are provided for common use cases:

- [`single_vm`](./examples/single_vm) — provision a single virtual machine
- [`multiple_vm`](./examples/multiple_vm) — provision multiple virtual machines
- [`talos`](./examples/talos) — provision virtual machines for Talos Linux and bootstrap Talos cluster
