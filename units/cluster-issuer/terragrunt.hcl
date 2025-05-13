include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/cluster-issuer"
}

dependency "cert-manager" {
  config_path                             = "../cert-manager"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}