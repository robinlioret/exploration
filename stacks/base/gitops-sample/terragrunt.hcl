terraform {
  source = "${get_repo_root()}/modules/gitops-sample"
}

dependency "argo-cd" {
  config_path                             = "../argo-cd"
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