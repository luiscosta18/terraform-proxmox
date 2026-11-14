module "talos" {
  source = "../../modules/talos"

  cluster = local.talos_cluster

  controlplanes = local.talos_controlplanes
  workers       = local.talos_workers

  proxmox = local.talos_proxmox

  talos_image = local.talos_image

  machine_config_patches      = local.talos_machine_config_patches
  controlplane_config_patches = local.talos_controlplane_config_patches
}
