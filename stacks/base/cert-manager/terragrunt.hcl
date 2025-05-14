terraform {
  source = "${get_repo_root()}/modules/cert-manager"
}

dependency "cluster" {
  config_path                             = "../cluster"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}