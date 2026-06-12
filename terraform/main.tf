resource "proxmox_virtual_environment_vm" "vm" {

  for_each = local.active_vms

  vm_id     = each.value.vm_id
  name      = each.key
  node_name = each.value.node

  clone {
    vm_id     = each.value.template_id
    node_name = local.template_node
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

      servers = local.dns_servers

      domain = local.domain
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = local.gateway
      }
    }

    user_account {
      username = "henrik"

      keys = [
        trimspace(
          file("${path.module}/ssh/id_ed25519.pub")
        )
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

  filename = "${path.module}/../ansible/inventories/production/hosts.yml"

  content = templatefile(
    "${path.module}/templates/inventory.tftpl",
    {
      vms = local.active_vms
    }
  )
}

resource "local_file" "prometheus_targets" {

  filename = "${path.module}/generated/demo-targets.yml"

  content = templatefile(
    "${path.module}/templates/prometheus-targets.tftpl",
    {
      vms = local.active_vms
    }
  )
}
