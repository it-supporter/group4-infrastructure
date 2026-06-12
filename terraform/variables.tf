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

variable "pair_count" {

  description = "Number of Cyber Range training pairs"

  type = number

  default = 0

  validation {

    condition = (
      var.pair_count >= 0 &&
      var.pair_count <= 10
    )

    error_message = "pair_count must be between 0 and 10."
  }
}
