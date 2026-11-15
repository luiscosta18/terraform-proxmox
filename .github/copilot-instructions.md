# Repository instructions

- Keep reusable modules focused and configurable through inputs. Configure providers in examples, not reusable modules.
- When changing a module's behavior or interface, update its README and a relevant example.
- Module READMEs are generated with `terraform-docs`; preserve the generated documentation markers and let the configured pre-commit hook update the content.
- Pin GitHub Actions to full commit SHAs and retain the corresponding version as an inline comment.
- Run `pre-commit run --all-files` before submitting changes. This runs OpenTofu formatting and validation, TFLint, and Terraform documentation checks; CI runs these checks for pull requests.
- Do not commit credentials, OpenTofu state, or machine-specific configuration.

## Talos module (`modules/talos`)

This module provisions a full Talos Linux Kubernetes cluster on Proxmox end-to-end: machine secrets → ISO download → VMs → machine config → apply → bootstrap → kubeconfig.

**VIP vs real IP** — the most critical rule in this module.

| Resource | Address to use |
|---|---|
| `cluster.endpoint` (Kubernetes API) | VIP `:6443` |
| `talos_client_configuration` endpoints (Talos API) | VIP `:50000` |
| `talos_machine_configuration_apply` node/endpoint | Real DHCP IP |
| `talos_machine_bootstrap` node/endpoint | Real DHCP IP |
| `talos_cluster_kubeconfig` node/endpoint | Real DHCP IP |

Using the VIP for bootstrap fails because the VIP is not active until the first control-plane is running. The code has explicit comments on every resource enforcing this — preserve them.

**IP filtering** — `local.controlplane_ips` and `local.worker_ips` discard loopback, link-local (`169.254.x`), `10.0.0.0/8`, and the VIP. This assumes nodes are **not** on a 10.x network. If the LAN uses 10.x, remove or narrow the `!startswith(ip, "10.")` condition.

**Bootstrap node** — `sort(keys(var.controlplanes))[0]` (lexicographically first key). Never rename control-plane keys after a cluster is bootstrapped — it re-selects the bootstrap node and triggers dependent resource recreation.

**Machine secrets** — `talos_machine_secrets` is created once per cluster. `ignore_changes = [talos_version]` prevents recreation on OS upgrades; Talos upgrades go through `talosctl upgrade`. Deleting this resource from state requires a full cluster rebuild.

**Config patch order** — patches are applied left-to-right; later patches override earlier ones:
1. `var.machine_config_patches` (all nodes)
2. `var.controlplane_config_patches` or `var.worker_config_patches`
3. Network patch — DHCP via `deviceSelector { physical = true }` + VIP (control-plane only)
4. `UnattendedInstallConfig` — `/dev/sda`, `wipe = false`
5. `KubeNodeConfig` — per-node labels
6. `UserVolumeConfig` — Longhorn on `/dev/sdb` (only when `longhorn_disk_size` is set)

Always write patches with `yamlencode()` and pass them as `list(string)`.

**Longhorn data disk** — when `longhorn_disk_size` is set, a `scsi1` Proxmox disk (`ssd = true`, `discard = "on"`) and a `UserVolumeConfig` patch for `/dev/sdb` → `/var/mnt/longhorn` are created together via the same conditional. Keep them in sync. Proxmox reports these disks as rotational even with `ssd=1`; Longhorn uses the filesystem path, not SSD metadata.

**VM configuration** — all VMs use machine type `q35`, BIOS `ovmf` (Secure Boot), `cpu type = "host"`, `scsi_hardware = "virtio-scsi-pci"`. EFI disk uses `ignore_changes = [pre_enrolled_keys]` to avoid churn on routine updates.

**Image factory (`examples/talos`)** — builds a custom SecureBoot schematic with three required extensions: `siderolabs/iscsi-tools`, `siderolabs/util-linux-tools`, `siderolabs/qemu-guest-agent`. A `precondition` validates all three are available. Always use `iso_secureboot` and `installer_secureboot` URLs from `talos_image_factory_urls`. Add new extensions to both `exact_filters.names` and the `precondition` check.

**Example topology** — `examples/talos/locals.tofu` encodes the homelab cluster: 3 control-planes + 2 workers, all 4 cores / 8192 MB / 40 GB OS disk / 40 GB Longhorn disk, Talos `v1.14.6`, Kubernetes `1.37.2`, single Proxmox node `pve`, datastores `local` / `local-lvm`, bridge `vmbr0`. VMIDs are auto-assigned by Proxmox. Global patches: delete Flannel CNI, enable kubelet `rotate-server-certificates`. Control-plane patches: disable kube-proxy, grant `os:etcd:backup` to namespace `talos-backup`.

**Gitignored** — `*.tfvars` (endpoint, token, VIP) and `examples/talos/talosconfig` are never committed. `terraform.tfstate` in `examples/talos/` is committed intentionally (no remote backend). Copy `terraform.tfvars.example` → `terraform.tfvars` and fill in real values before `tofu plan`.

## Upgrading Talos and Kubernetes

### Talos OS upgrade

Bump `talos_version` in `examples/talos/locals.tofu`. Run `tofu apply` — this regenerates the Image Factory schematic and updates `talos_installer_image` in state. The existing nodes are **not** automatically rebooted; you must drive the rolling upgrade with `talosctl`:

```bash
# 1. Install the matching talosctl client
curl -Lo talosctl https://github.com/siderolabs/talos/releases/download/v<talos_version>/talosctl-linux-amd64
chmod +x talosctl && sudo mv talosctl /usr/local/bin/talosctl

# 2. Get the new installer image from Terraform output
export TALOSCONFIG="$PWD/examples/talos/talosconfig"
IMAGE="$(cd examples/talos && tofu output -raw talos_installer_image)"

# 3. Upgrade workers first, then control-planes one at a time
# Replace IPs with current DHCP addresses from: talosctl get members
talosctl upgrade -n <worker_ip>       -e <vip_or_cp_ip> --image "$IMAGE" --wait
talosctl upgrade -n <controlplane_ip> -e <vip_or_cp_ip> --image "$IMAGE" --wait
```

Always upgrade `talosctl` to the same version as the target OS before running
`talosctl upgrade`. The installer image is a `metal-installer-secureboot` image
produced by Image Factory — never use a plain `ghcr.io/siderolabs/installer` URL.

### Kubernetes upgrade

Bump `kubernetes_version` in `examples/talos/locals.tofu`. Run `tofu apply` to
update generated machine configs, then drive the rolling upgrade with `talosctl`:

```bash
talosctl upgrade-k8s --to <kubernetes_version> -n <any_controlplane_ip> -e <vip_or_cp_ip>
```

`upgrade-k8s` drains nodes and updates the control-plane components and kubelet
sequentially. Run it from a single control-plane node; it handles the rest.

### After any upgrade

Verify all members are on the expected version:

```bash
talosctl version        -e <vip_or_cp_ip>
talosctl get members    -e <vip_or_cp_ip>
talosctl etcd status    -e <vip_or_cp_ip>
kubectl get nodes -o wide
```
