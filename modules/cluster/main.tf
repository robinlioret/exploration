resource "kind_cluster" "this" {
  name            = var.name
  kubeconfig_path = var.kubeconfig_path
  wait_for_ready  = true
  node_image = var.node_image

  kind_config {
    api_version = "kind.x-k8s.io/v1alpha4"
    kind       = "Cluster"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"

      labels = {
        "feature.node.kubernetes.io/port-mapping" = "true"
      }

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }
}