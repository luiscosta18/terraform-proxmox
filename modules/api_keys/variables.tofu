variable "api_key" {
  description = "Proxmox API token configuration. The user must already exist."

  type = object({
    user_id               = string
    token_name            = string
    comment               = optional(string)
    expiration_date       = optional(string)
    privileges_separation = optional(bool, false)
  })
}

variable "group" {
  description = "Proxmox group configuration."

  type = object({
    group_id = string
    comment  = optional(string)
  })
}

variable "permission" {
  description = "ACL path and role assignment for the group."

  type = object({
    path      = string
    propagate = optional(bool, true)
  })
}

variable "role" {
  description = "Custom Proxmox role and its privileges."

  type = object({
    role_id    = string
    privileges = set(string)
  })
}
