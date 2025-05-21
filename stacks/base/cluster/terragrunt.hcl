terraform {
  source = "${get_repo_root()}/modules/cluster"
}

inputs = {
  preset    = "c1w0-exposed" # Prefer ONE node, it makes easier to work with storage.
  data_path = "${get_repo_root()}/data/cluster"
}
