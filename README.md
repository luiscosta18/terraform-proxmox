# Terraform Proxmox

Reusable Terraform modules for provisioning and managing virtual machines on [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment) with the [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest) provider, including infrastructure for [Talos Linux](https://www.talos.dev/) Kubernetes clusters managed with the [siderolabs/talos](https://registry.terraform.io/providers/siderolabs/talos/latest) provider.

## Usage

Examples are provided for common use cases:

- [`api_keys`](./examples/api_keys) — create an API token with VM, disk, and VM property management permissions
- [`single_vm`](./examples/single_vm) — provision a single virtual machine
- [`multiple_vm`](./examples/multiple_vm) — provision multiple virtual machines
- [`talos`](./examples/talos) — provision virtual machines for Talos Linux and bootstrap Talos cluster

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
