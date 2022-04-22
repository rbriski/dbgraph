variable "LINODE_API_TOKEN" {}
variable "EMAIL" {}
variable "NEO4J_PASSWORD" {}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "linode" "force" {
  image                 = "linode/ubuntu20.04"
  image_description     = "GraphDB Image"
  image_label           = "graphdb-image-${local.timestamp}"
  instance_label        = "graphdb-linode-${local.timestamp}"
  instance_type         = "g6-nanode-1"
  linode_token          = "${var.LINODE_API_TOKEN}"
  region                = "us-east"
  ssh_username          = "root"
  authorized_keys       = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDS8CRlxUgy0lj/8BdFmC8Ot7A4FVKs2oPChWT8V4mzBequiKZj3jhw3ByOtJASg1VR61UEeg8DFPMzNlKQ1clSv4+KxCg4jex95Lv6C0DsoH4+TSSXDOUXsBeWeqs3UMjwFG6OYSpfoF65Sq8++FGVM42A+DK4tIHMGRrCtiwNGx7aBJy3lIQ5EHsBTIGd7qNWOood+iL2AwSpPRlQqducRAEyfBaFD7i3N7XqnYtYmBTif7WdW6yZ4h3aWaAv/SvMnsynqb+7DnaP+Q1gAcOuSSCGL1X4nkzIS88Sg1VC+kdN46nbllP++6W9oAnscUZ1offBM6OxNppK7gRQKecA9pWPgukgeIXpKRRrGUm7VQJLeK4q/hD9/Cwn6zCsI9Swu8tHXF4SJQQVMOYiAIlRn6MvaJRp3KQ1JM453KCTRDhBpfuv5UKsiJYyFjaEHdipRiPM+mJG0YFHS1+YywkmrC0kqh7VmdqUkHTrBPfPfVD2SKhjWcp2XV6l31L5elc= bbriski@Bobs-MacBook-Pro.local"]
}

build {
  sources = ["source.linode.force"]

  provisioner "shell" {
    execute_command = "{{.Vars}} DEBIAN_FRONTEND='noninteractive' sudo -S -E '{{.Path}}'"
    script = "scripts/setup.sh"
  }
    provisioner "file" {
    source="scripts/neo4j.conf"
    destination="/etc/neo4j/neo4j.conf"
  }
  # provisioner "file" {
  #   source="scripts/force.service"
  #   destination="/etc/systemd/system/force.service"
  # }
  # provisioner "file" {
  #   source="scripts/nginx.conf"
  #   destination="/etc/nginx/nginx.conf"
  # }
  # provisioner "file" {
  #   source="scripts/environment"
  #   destination="/etc/environment"
  # }
  # provisioner "shell" {
  #   script = "scripts/get_code.sh"
  # }
  provisioner "shell" {
    environment_vars = [
      "NEO4J_PASSWORD=${var.NEO4J_PASSWORD}"
    ]
    execute_command = "{{.Vars}} DEBIAN_FRONTEND='noninteractive' sudo -S -E '{{.Path}}'"
    script = "scripts/finish.sh"
  }
}

packer {
  required_plugins {
    linode = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}