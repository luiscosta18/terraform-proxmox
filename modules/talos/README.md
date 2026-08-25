<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.111 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | >= 0.11.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.111 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | >= 0.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [proxmox_download_file.talos_iso](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/download_file) | resource |
| [proxmox_virtual_environment_vm.controlplane](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [proxmox_virtual_environment_vm.worker](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [talos_cluster_kubeconfig.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/cluster_kubeconfig) | resource |
| [talos_machine_bootstrap.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_bootstrap) | resource |
| [talos_machine_configuration_apply.controlplane](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_configuration_apply) | resource |
| [talos_machine_configuration_apply.worker](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_configuration_apply) | resource |
| [talos_machine_secrets.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_secrets) | resource |
| [talos_client_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/client_configuration) | data source |
| [talos_machine_configuration.controlplane](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration) | data source |
| [talos_machine_configuration.worker](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Talos/Kubernetes cluster configuration. | <pre>object({<br/>    name               = string<br/>    endpoint           = string<br/>    talos_version      = string<br/>    kubernetes_version = string<br/>    vip                = string<br/>  })</pre> | n/a | yes |
| <a name="input_controlplane_config_patches"></a> [controlplane\_config\_patches](#input\_controlplane\_config\_patches) | Talos configuration patches applied to control-plane nodes. | `list(string)` | `[]` | no |
| <a name="input_controlplanes"></a> [controlplanes](#input\_controlplanes) | Talos control-plane VM inventory. | <pre>map(object({<br/>    vmid      = number<br/>    node_name = string<br/><br/>    mac_address = optional(string)<br/><br/>    cores     = optional(number, 2)<br/>    memory    = optional(number, 4096)<br/>    disk_size = optional(number, 32)<br/><br/>    labels = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_machine_config_patches"></a> [machine\_config\_patches](#input\_machine\_config\_patches) | Talos configuration patches applied to all nodes. | `list(string)` | `[]` | no |
| <a name="input_network"></a> [network](#input\_network) | Network configuration for the Talos cluster. | <pre>object({<br/>    cidr      = string<br/>    gateway   = string<br/>    vip       = string<br/>    interface = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_proxmox"></a> [proxmox](#input\_proxmox) | Proxmox storage and network configuration. | <pre>object({<br/>    image_datastore = string<br/>    disk_datastore  = string<br/>    network_bridge  = string<br/>  })</pre> | n/a | yes |
| <a name="input_talos_image"></a> [talos\_image](#input\_talos\_image) | Talos installation image configuration. | <pre>object({<br/>    iso_url            = string<br/>    installer_url      = string<br/>    checksum           = optional(string)<br/>    checksum_algorithm = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_worker_config_patches"></a> [worker\_config\_patches](#input\_worker\_config\_patches) | Talos configuration patches applied to worker nodes. | `list(string)` | `[]` | no |
| <a name="input_workers"></a> [workers](#input\_workers) | Talos worker VM inventory. | <pre>map(object({<br/>    vmid      = number<br/>    node_name = string<br/><br/>    mac_address = optional(string)<br/><br/>    cores     = optional(number, 4)<br/>    memory    = optional(number, 8192)<br/>    disk_size = optional(number, 64)<br/><br/>    labels = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_controlplane_ips"></a> [controlplane\_ips](#output\_controlplane\_ips) | IPv4 addresses of the Talos control-plane nodes. |
| <a name="output_controlplane_vmids"></a> [controlplane\_vmids](#output\_controlplane\_vmids) | Proxmox VM IDs of the control-plane nodes. |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubernetes kubeconfig. |
| <a name="output_node_ips"></a> [node\_ips](#output\_node\_ips) | IPv4 addresses of all Talos nodes. |
| <a name="output_talosconfig"></a> [talosconfig](#output\_talosconfig) | Talos client configuration. |
| <a name="output_worker_ips"></a> [worker\_ips](#output\_worker\_ips) | IPv4 addresses of the Talos worker nodes. |
| <a name="output_worker_vmids"></a> [worker\_vmids](#output\_worker\_vmids) | Proxmox VM IDs of the worker nodes. |

<!-- END_TF_DOCS -->
