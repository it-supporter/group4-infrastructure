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

variable "demo_node_count" {
  description = "Number of demo nodes"

  type    = number
  default = 0
}
