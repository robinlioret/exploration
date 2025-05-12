#!/bin/bash
# MUST BE RUN FROM THE NEW ENVIRONMENT DIRECTORY.
# Initialize a Terraform environment.

test -z "$1" && exit 1

if test -d environments; then
    cd environments
fi

mkdir "$1" && cd "$1"

echo "1.11.4" > .terraform-version

touch outputs.tf
touch variables.tf

cat > terraform.tf << EOF
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
EOF

cat > base.tf << EOF
module "dns" {
  source = "../../modules/dns"

  domain = "sandbox.local"
}

module "cluster" {
  source = "../../modules/cluster"

  name = "sandbox"
}

EOF

cat > README.md << EOF
# X

Description of what the module is used for.
EOF