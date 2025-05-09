output "cluster_name" {
  value = "kind-${var.name}"
}

output "kubeconfig_path" {
  value = var.kubeconfig_path
}