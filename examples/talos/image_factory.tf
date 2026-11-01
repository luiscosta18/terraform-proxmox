data "talos_image_factory_extensions_versions" "required" {
  talos_version = local.talos_cluster.talos_version

  exact_filters = {
    names = [
      "siderolabs/iscsi-tools",
      "siderolabs/util-linux-tools",
      "siderolabs/qemu-guest-agent",
    ]
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = data.talos_image_factory_extensions_versions.required.extensions_info[*].name
      }
    }
  })

  lifecycle {
    precondition {
      condition = alltrue([
        for extension in [
          "siderolabs/iscsi-tools",
          "siderolabs/util-linux-tools",
          "siderolabs/qemu-guest-agent",
        ] :
        contains(
          [for available in data.talos_image_factory_extensions_versions.required.extensions_info : available.name],
          extension
        )
      ])
      error_message = "Talos Image Factory must provide iscsi-tools, util-linux-tools, and qemu-guest-agent for the selected Talos version."
    }
  }
}

data "talos_image_factory_urls" "this" {
  talos_version = local.talos_cluster.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = "metal"
}
