unit "local-dns" {
  source = "${get_repo_root()}/units/local-dns"
  path   = "local-dns"
}

unit "local-cluster" {
  source = "${get_repo_root()}/units/local-cluster"
  path   = "local-cluster"
}