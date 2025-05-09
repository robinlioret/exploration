output "cluster_name" {
  value = [kind_cluster.this.endpoint, "kind-${var.name}"][1]
}

output "kubeconfig_path" {
  value = [kind_cluster.this.endpoint, var.kubeconfig_path][1]
}

output "endpoint" {
  value = kind_cluster.this.endpoint
}