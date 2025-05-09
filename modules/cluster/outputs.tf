output "cluster_name" {
  value = kind_cluster.this.endpoint != null ? "kind-${var.name}" : null # Forces Terraform to wait for the cluster to be create before computing further resources.
}

output "kubeconfig_path" {
  value = kind_cluster.this.endpoint != null ? local.kubeconfig_path : null # Forces Terraform to wait for the cluster to be create before computing further resources.
}

output "endpoint" {
  value = kind_cluster.this.endpoint != null ? kind_cluster.this.endpoint : null # Forces Terraform to wait for the cluster to be create before computing further resources.
}