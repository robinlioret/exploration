output "cluster_name" {
  value = "kind-${var.name}"
}

output "kubeconfig_path" {
  value = var.kubeconfig_path
}

output "endpoint" {
  value = kind_cluster.this.endpoint
}