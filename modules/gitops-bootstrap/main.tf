resource "kubernetes_manifest" "kustimize_aoa" {
  manifest = yamldecode(templatefile("${path.module}/manifests/kustomize.aoa.yaml", { git_repo = var.git_repo }))
}

resource "kubernetes_manifest" "helm_aoa" {
  manifest = yamldecode(templatefile("${path.module}/manifests/helm.aoa.yaml", { git_repo = var.git_repo }))
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret" "ca-cert-secret" {
  metadata {
    name      = "ca-cert"
    namespace = "cert-manager"
  }

  data = {
    "ca.crt"  = file("${path.module}/ca/ca.crt")
    "tls.crt" = file("${path.module}/ca/tls.crt")
    "tls.key" = file("${path.module}/ca/tls.key")
  }
}
