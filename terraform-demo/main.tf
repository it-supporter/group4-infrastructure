resource "proxmox_virtual_environment_vm" "vm" {

  for_each = local.demo_vms

  vm_id     = each.value.vm_id
  name      = each.key
  node_name = each.value.node

  clone {
    vm_id     = 666
    node_name = "s12"
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  agent {
    enabled = true

    wait_for_ip {
      enabled = false
    }
  }

  operating_system {
    type = "l26"
  }

  initialization {

    datastore_id = "Ceph-Storage-Pool"

    dns {
      servers = [
        "10.4.10.20",
        "10.4.10.21"
      ]

      domain = "gruppe4.local"
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
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
    model  = "virtio"
  }

  disk {
    datastore_id = "Ceph-Storage-Pool"
    interface    = "scsi0"
    size         = 20
  }
}

resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../ansible/inventories/demo/hosts.yml"

  content = templatefile(
    "${path.module}/templates/inventory.tftpl",
    {
      vms = local.demo_vms
    }
  )
}

resource "local_file" "prometheus_targets" {

  filename = "${path.module}/generated/demo-targets.yml"

  content = templatefile(
    "${path.module}/templates/prometheus_targets.tftpl",
    {
      vms = local.demo_vms
    }
  )
}
