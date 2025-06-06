terraform {
  source = "${get_repo_root()}/modules/gitops-bootstrap"
}

inputs = {
  git_repo = "http://forgejo.sandbox.local:3000/administrator/exploration-gitops-local.git"
}

dependency "argocd" {
  config_path                             = "../argocd"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}