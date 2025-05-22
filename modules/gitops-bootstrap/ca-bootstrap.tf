resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret" "ca_cert_secret" {
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

resource "kubernetes_manifest" "ca_cm" {
  manifest = yamldecode(templatefile("${path.module}/manifests/ca-bootstrap/cm.yaml", { cert = file("${path.module}/ca/ca.crt") }))
}

resource "kubernetes_manifest" "ca_daemonset" {
  manifest = yamldecode(templatefile("${path.module}/manifests/ca-bootstrap/daemonset.yaml", {}))
}
