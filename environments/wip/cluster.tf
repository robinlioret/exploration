module "cluster" {
  source = "../../modules/cluster"

  name = "sandbox" # TODO change the name
}

output "kubeconfig" {
  value = module.cluster.kubeconfig_path
}

resource "kubernetes_namespace" "name" {
  metadata {
    name = "yolo"
  }
}