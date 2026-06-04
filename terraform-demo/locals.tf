locals {

  proxmox_nodes = [
    "s10",
    "s11",
    "s12"
  ]

  demo_vms = merge(

    {
      for i in range(var.student_count) :

      format("DEMO-STUDENT%02d", i + 1) => {

        pair = i + 1

        vm_id = 200 + (i * 2)

        ip = format(
          "10.4.10.%d",
          200 + (i * 2)
        )

        node = local.proxmox_nodes[
          i % length(local.proxmox_nodes)
        ]

        cores  = 1
        memory = 1024

        role = "student"
      }
    },

    {
      for i in range(var.student_count) :

      format("DEMO-TARGET%02d", i + 1) => {

        pair = i + 1

        vm_id = 201 + (i * 2)

        ip = format(
          "10.4.10.%d",
          201 + (i * 2)
        )

        node = local.proxmox_nodes[
          i % length(local.proxmox_nodes)
        ]

        cores  = 1
        memory = 1024

        role = "target"
      }
    }
  )
}
