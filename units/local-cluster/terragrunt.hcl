include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/local-cluster"
}

inputs = {
  preset = "c1w3-exposed"
}

dependencies {
  paths = ["../local-dns"]
}
