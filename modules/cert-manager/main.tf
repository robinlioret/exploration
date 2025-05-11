resource "helm_release" "this" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.17.2"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "crds.enabled"
    value = true
  }
}

resource "kubernetes_manifest" "root-issuer" {
  depends_on = [helm_release.this]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "root-issuer"
    }

    spec = {
      selfSigned = {}
    }
  }
}

resource "kubernetes_manifest" "ca-cert" {
  depends_on = [kubernetes_manifest.root-issuer]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "ca"
      namespace = "cert-manager"
    }

    spec = {
      isCA       = true
      commonName = var.common_name
      secretName = "ca-cert"
      privateKey = {
        algorithm = "ECDSA"
        size      = 256
      }
      issuerRef = {
        name  = kubernetes_manifest.root-issuer.manifest.metadata.name
        kind  = kubernetes_manifest.root-issuer.manifest.kind
        group = "cert-manager.io"
      }
    }
  }
}

resource "kubernetes_manifest" "ca-issuer" {
  depends_on = [kubernetes_manifest.ca-issuer]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "ca-issuer"
    }

    spec = {
      ca = {
        secretName = kubernetes_manifest.ca-cert.manifest.spec.secretName
      }
    }
  }
}

# data "kubernetes_ressource" "ca-cert" {
#   api_version = ""
# }