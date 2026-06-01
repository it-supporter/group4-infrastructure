resource "proxmox_virtual_environment_vm" "terraform01" {

  name      = "terraform01"
  node_name = "s12"

  clone {
    vm_id = 666
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  initialization {

    datastore_id = "Ceph-Storage-Pool"

    dns {
      servers = ["10.4.10.20"]
      domain  = "gruppe4.local"
    }

    ip_config {
      ipv4 {
        address = "10.4.10.230/24"
        gateway = "10.4.10.1"
      }
    }

    user_account {
      username = "henrik"

      keys = [
        file("${path.module}/ssh/id_ed25519.pub")
      ]
    }
  }

  network_device {
    bridge = "vmbr1"
  }

  disk {
    datastore_id = "Ceph-Storage-Pool"
    interface    = "scsi0"
    size         = 20
  }
}
