unit "local-dns" {
  source = "${get_repo_root()}/units/local-dns"
  path   = "local-dns"
}

unit "local-cluster" {
  source = "${get_repo_root()}/units/local-cluster"
  path   = "local-cluster"
}

unit "cert-manager" {
  source = "${get_repo_root()}/units/cert-manager"
  path   = "cert-manager"
}

unit "cluster-issuer" {
  source = "${get_repo_root()}/units/cluster-issuer"
  path   = "cluster-issuer"
}