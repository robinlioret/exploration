include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/local-cluster"
}

inputs = {
  preset = "c1w3-exposed"
}