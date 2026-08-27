module "talos" {
  source = "../../modules/talos"

  cluster = local.talos_cluster

  controlplanes = local.talos_controlplanes
  workers       = local.talos_workers

  proxmox = local.talos_proxmox

  talos_image = local.talos_image
}
