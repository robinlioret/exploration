resource "docker_image" "coredns" {
  name = "coredns/coredns:latest"
}

resource "docker_container" "coredns" {
  name         = "coredns"
  image        = docker_image.coredns.image_id
  command      = ["-conf", "/etc/coredns/Corefile", "-dns.port", "53"]
  network_mode = "host"
  ports {
    internal = 53
    external = 53
  }
  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  
  volumes {
    container_path = "/etc/coredns/Corefile"
    host_path      = local.coredns_config_path
    read_only      = true
  }
  volumes {
    container_path = "/etc/coredns/db.${var.domain}"
    host_path      = local.coredns_zonefile_path
    read_only      = true
  }
}

locals {
  coredns_config_path   = abspath("${path.root}/corefile.temp.dns")
  coredns_zonefile_path = abspath("${path.root}/zonefile.temp.dns")
}

resource "local_file" "corefile" {
  filename = abspath("${path.root}/corefile.temp.dns")
  content  = templatefile("${path.module}/templates/corefile.tftpl", { domain = var.domain })
}

resource "local_file" "zonefile" {
  filename = local.coredns_zonefile_path
  content  = templatefile("${path.module}/templates/zonefile.tftpl", { domain = var.domain })
}
