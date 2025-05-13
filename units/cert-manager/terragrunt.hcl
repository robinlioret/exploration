include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/cert-manager"
}

dependency "local-cluster" {
  config_path                             = "../local-cluster"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}