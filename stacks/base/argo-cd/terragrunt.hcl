terraform {
  source = "${get_repo_root()}/modules/argo-cd"
}

dependency "cluster-issuer" {
  config_path                             = "../cert-issuer"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}

dependency "cluster" {
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