terraform {
  source = "${get_repo_root()}/modules/forgejo"
}

inputs = {
  data_dir = "${get_repo_root()}/data/forgejo"
}

dependency "dns" {
  config_path                             = "../dns"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}
