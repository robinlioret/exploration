terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.0.0,<3"
    }
  }
}

provider "kubernetes" {
  config_context = module.cluster.cluster_name
  host           = module.cluster.endpoint
  config_path    = module.cluster.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = module.cluster.kubeconfig_path
  }
}