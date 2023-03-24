terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "tcp://${var.ssh_host}:2375/"
}

resource "docker_image" "prestashop" {
  name         = "prestashop/prestashop"
  pull_triggers = ["prestashop/prestashop"]
}

resource "docker_container" "prestashop" {
  name  = "prestashop"
  image = docker_image.prestashop.name

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "/opt/prestashop"
    container_path = "/var/www/html"
  }

  env = [
    "PS_DOMAIN=sun.fr",
    "PS_INSTALL_AUTO=1",
    "PS_ERASE_DB=0",
    "DB_SERVER=192.168.8.131",
    "DB_PORT=3306",
    "DB_NAME=test",
    "DB_USER=docker",
    "DB_PASSWD=li",
    "DB_PREFIX=ps_",
    "PS_LANGUAGE=fr",
    "PS_COUNTRY=fr",
    "PS_CURRENCY_DEFAULT=1",
    "PS_CURRENCIES=1,2",
    "PS_FOLDER_ADMIN=admin",
    "PS_FOLDER_BO=backend",
    "ADMIN_MAIL=naow@sun.fr",
    "ADMIN_PASSWD=Simplon59",
    "FIRSTNAME=naow",
    "LASTNAME=naow",
    "EMAIL=naow@sun.fr",
    "PASSWORD=Simplon59",
  ]
}
