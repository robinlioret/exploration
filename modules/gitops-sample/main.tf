resource "kubernetes_manifest" "sample-2048-raw" {
  manifest = yamldecode(file("${path.module}/manifests/2048.raw.yaml"))
}
