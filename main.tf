variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}

module "install" {
  source        = "./modules/install"
  ssh_host      = var.ssh_host
  ssh_user      = var.ssh_user
  ssh_key               = var.ssh_key
}
module "docker" {
  source        = "./modules/docker"
  ssh_host      = var.ssh_host
  ssh_user      = var.ssh_user
  ssh_key       = var.ssh_key
}
module "dump" {
  source        = "./modules/dump"
  ssh_host      = var.ssh_host
  ssh_user      = var.ssh_user
  ssh_key       = var.ssh_key
}