locals {
  cluster_created = kind_cluster.this != null ? true : false
}

output "cluster_name" {
  value = local.cluster_created ? "kind-${var.name}" : null # Forces Terraform to wait for the cluster to be create before computing further resources.
}

output "kubeconfig_path" {
  value = local.cluster_created ? local.kubeconfig_path : null # Forces Terraform to wait for the cluster to be create before computing further resources.
}

output "endpoint" {
  value = local.cluster_created ? kind_cluster.this.endpoint : null # Forces Terraform to wait for the cluster to be create before computing further resources.
}