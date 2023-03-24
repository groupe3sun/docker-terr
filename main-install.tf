resource "null_resource" "ssh_target" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y >/dev/null",
      "sudo apt install -y curl",
      "sudo apt install -y apache2",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod 755 get-docker.sh",
      "sudo ./get-docker.sh >/dev/null",
      "sudo usermod -a -G www-data ais",
      "sudo chgrp -R www-data /var/www/html",
      "sudo chmod -R g+w /var/www/html"
    ]
  }
  provisioner "file" {
    source      = "${path.module}/startup-options.conf"
    destination = "/tmp/startup-options.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d/",
      "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker",
      "sudo usermod -aG docker ais",
#      "sudo docker pull php:7.4-apache",
#      "sudo docker pull prestashop/prestashop"
    ]
  }
}
