terraform {
  source = "${get_repo_root()}/modules/forgejo"
}

inputs = {
  data_dir = "${get_repo_root()}/data/forgejo"
}