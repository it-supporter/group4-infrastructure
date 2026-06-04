variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_token_id" {
  type = string
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

variable "vms" {
  description = "VM definitions"

  type = map(object({
    vm_id  = number
    node   = string
    ip     = string
    cores  = number
    memory = number
    role   = string
  }))

  default = {}
}

variable "demo_node_count" {
  description = "Number of demo K3s nodes"

  type    = number
  default = 0
}
