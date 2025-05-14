resource "kubernetes_manifest" "root_issuer" {
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

resource "kubernetes_manifest" "ca_cert" {
  depends_on = [kubernetes_manifest.root_issuer]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "ca"
      namespace = "cert-manager"
    }

    spec = {
      isCA       = true
      commonName = "Dummy Inc."
      secretName = "ca-cert"
      privateKey = {
        algorithm = "ECDSA"
        size      = 256
      }
      issuerRef = {
        name  = kubernetes_manifest.root_issuer.manifest.metadata.name
        kind  = kubernetes_manifest.root_issuer.manifest.kind
        group = "cert-manager.io"
      }
    }
  }
}

resource "kubernetes_manifest" "ca_issuer" {
  depends_on = [kubernetes_manifest.ca_issuer]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "ca-issuer"
    }

    spec = {
      ca = {
        secretName = kubernetes_manifest.ca_cert.manifest.spec.secretName
      }
    }
  }
}

data "kubernetes_secret" "ca_cert" {
  depends_on = [kubernetes_manifest.ca_cert, kubernetes_manifest.ca_issuer]
  metadata {
    name      = "ca-cert"
    namespace = "cert-manager"
  }
}

resource "local_file" "certificate" {
  filename = var.ca_cert_export_path
  content  = data.kubernetes_secret.ca_cert.data["ca.crt"]
}
