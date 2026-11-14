variable "proxmox_endpoint" {
  description = "Proxmox API endpoint URL."
  type        = string
}

variable "proxmox_api_token" {
  description = "Existing administrative API token used to create the new token and ACL."
  type        = string
  sensitive   = true
}

variable "api_key_user_id" {
  description = "Existing Proxmox user ID. The user must already be a member of api_key_group_id."
  type        = string
  default     = "terraform@pve"
}

variable "api_key_token_name" {
  description = "Name of the API token to create."
  type        = string
  default     = "terraform-vm-management"
}

variable "api_key_group_id" {
  description = "Group receiving VM management permissions."
  type        = string
  default     = "terraform-vm-management"
}
