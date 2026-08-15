// data.tf - example data sources for Proxmox
// These blocks are commented out as provider/data source names and availability
// vary between providers. Uncomment and adjust to match your chosen provider.

/*
# List nodes
data "proxmox_nodes" "all" {}

# Fetch a specific storage (by name)
data "proxmox_storage" "default" {
  name = "local-lvm"
}

# Find a template image by name or pattern
data "proxmox_templates" "ubuntu_cloud" {
  filter = {
    name = "ubuntu-22.04-cloudimg"
  }
}
*/

// If your provider exposes different data sources, add them here and map into locals.
