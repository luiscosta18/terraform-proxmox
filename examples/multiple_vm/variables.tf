variable "vm_name_prefix" {
  description = "Prefix used for VM names."
  type        = string
  default     = "ubuntu"
}

variable "vm_count" {
  description = "Number of Ubuntu VMs to create."
  type        = number
  default     = 2

  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 100
    error_message = "vm_count must be between 1 and 100."
  }
}
