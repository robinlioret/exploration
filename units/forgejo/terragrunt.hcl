include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "."
}

inputs = {
  data-dir = "${get_repo_root()}/data/forgejo"
}