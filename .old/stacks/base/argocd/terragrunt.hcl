terraform {
  source = "${get_repo_root()}/modules/argocd"
}

dependency "cluster" {
  config_path                             = "../cluster"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}

dependency "dns" {
  config_path                             = "../dns"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}

dependency "forgejo" {
  config_path                             = "../forgejo"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}
