resource "docker_image" "forgejo" {
  name = "codeberg.org/forgejo/forgejo:11"
}

resource "docker_container" "forgejo" {
  name         = "forgejo"
  image        = docker_image.forgejo.image_id
  network_mode = "host"
  ports {
    internal = 3000
    external = 3000
  }
  ports {
    internal = 22
    external = 3022
  }

  volumes {
    container_path = "/etc/timezone"
    host_path      = "/etc/timezone"
    read_only      = true
  }
  volumes {
    container_path = "/etc/localtime"
    host_path      = "/etc/localtime"
    read_only      = true
  }
  volumes {
    container_path = "/data"
    host_path      = var.data_dir
  }
}
