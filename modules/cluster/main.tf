locals {
  config = yamldecode(file("${path.module}/presets/${var.preset}.yaml"))
}

resource "kind_cluster" "this" {
  name           = "sandbox"
  wait_for_ready = true

  kind_config {
    api_version = local.config.apiVersion
    kind        = local.config.kind

    dynamic "node" {
      for_each = local.config.nodes
      content {
        role   = node.value.role
        labels = try(node.value.labels, null)

        dynamic "extra_port_mappings" {
          for_each = try(node.value.extraPortMappings, [])
          content {
            container_port = extra_port_mappings.value.containerPort
            host_port      = extra_port_mappings.value.hostPort
          }
        }

        dynamic "extra_mounts" {
          for_each = try(node.value.extraMounts, [])
          content {
            host_path      = abspath("${var.data_path}/${var.preset}/${extra_mounts.value.hostPath}")
            container_path = extra_mounts.value.containerPath
          }
        }
      }
    }
  }
}
