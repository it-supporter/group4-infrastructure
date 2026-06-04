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

variable "student_count" {
  description = "Number of student/target pairs"

  type    = number
  default = 0
}
