provider "proxmox" {
  endpoint  = "" # add Proxmox endpoint
  api_token = "" # add Proxmox API token

  insecure = true

  ssh {
    agent    = true
    username = "root"
  }
}
