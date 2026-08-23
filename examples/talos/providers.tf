provider "proxmox" {
  endpoint  = ""
  api_token = ""

  insecure = true

  ssh {
    agent    = true
    username = "root"
  }
}

provider "talos" {}
