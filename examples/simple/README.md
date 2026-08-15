Example: proxmox-bgp module

This directory demonstrates how to call the module and configure the Proxmox provider.

Quickstart

1. Copy examples/simple/terraform.tfvars.example -> examples/simple/terraform.tfvars and fill in proxmox_endpoint, proxmox_username and proxmox_password (do NOT commit secrets).
2. Run:

   cd examples/simple
   terraform init
   terraform validate

3. To plan/apply (in a non-production/test environment):

   terraform plan -var-file=terraform.tfvars
   terraform apply -var-file=terraform.tfvars

Generating input/output docs locally

If you have docker installed, you can generate module inputs/outputs with terraform-docs:

  docker run --rm -v "$PWD/..":/workspace quay.io/terraform-docs/terraform-docs:latest markdown /workspace/modules/proxmox-bgp

This repository's CI will also run terraform-docs when configured.
