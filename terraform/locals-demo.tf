locals {

  demo_proxmox_nodes = [
    "s10",
    "s11",
    "s12"
  ]

  demo_vms = {

    for i in range(var.demo_node_count) :

    format("demo-k3s-%02d", i + 1) => {

      vm_id = 200 + i

      ip = format(
        "10.4.10.%d",
        200 + i
      )

      node = local.demo_proxmox_nodes[
        i % length(local.demo_proxmox_nodes)
      ]

      cores  = 1
      memory = 2048

      role = "demo"
    }
  }

  active_vms = (
    var.demo_node_count > 0
    ? local.demo_vms
    : var.vms
  )
}
