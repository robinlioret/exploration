unit "local-dns" {
  source = "${get_repo_root()}/units/local-dns"
  path   = "local-dns"
}

unit "cluster" {
  source = "${get_repo_root()}/units/cluster"
  path   = "cluster"
}

unit "cert-manager" {
  source = "${get_repo_root()}/units/cert-manager"
  path   = "cert-manager"
}

unit "cluster-issuer" {
  source = "${get_repo_root()}/units/cluster-issuer"
  path   = "cluster-issuer"
}