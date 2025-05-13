locals {
  kubeconfig_path = pathexpand(var.kubeconfig_path)
  config          = yamldecode(file("${path.module}/presets/${var.preset}.yaml"))
}

resource "kind_cluster" "this" {
  name            = var.name
  kubeconfig_path = local.kubeconfig_path
  wait_for_ready  = true
  node_image      = var.node_image

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
      }
    }
  }
}