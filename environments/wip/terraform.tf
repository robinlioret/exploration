terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">=0.8.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=3.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.5.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.36.0"
    }
  }
}

provider "kubernetes" {
  config_context = module.cluster.cluster_name
  host           = module.cluster.endpoint
  config_path    = module.cluster.kubeconfig_path
}
