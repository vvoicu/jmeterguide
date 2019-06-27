terraform {
  required_version = "< 0.12.0"
}

# Some local variables, which i don't want to handle through exported variables.
locals {
  stack        = "demo-stack"
  ssh_key_name = "demo-stack-ssh-key"
}

# Summoning the VPC module. Creating a VPC with default settings.
module "vpc" {
  source = "git::ssh://git@github.ecs-digital.co.uk/ECSD/playground-frame.git?ref=v1.0.0//modules/vpc"
  name   = "${local.stack}"
}

# Generating a number of animal names, which then we'll be using as domain names
module "animal" {
  source = "git::ssh://git@github.ecs-digital.co.uk/ECSD/playground-frame.git?ref=v1.0.0//modules/animal_names"
  count  = "${var.count}"
}

# Generating a specific SSH key, so the user doesn't have to have a key stored for AWS already.
resource "tls_private_key" "ssh_keypair" {
  count     = 1
  algorithm = "RSA"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${local.ssh_key_name}"
  public_key = "${tls_private_key.ssh_keypair.public_key_openssh}"

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh_keypair.private_key_pem}\" > ${local.ssh_key_name}.pem && chmod 400 ${local.ssh_key_name}.pem"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "rm -f ${local.ssh_key_name}.pem"
  }
}

# This is the module actually creating the linux instance. 
# You need to pass the animal names list, to allow the module to change hostnames for the instances.
module "linux_instances" {
  source                    = "git::ssh://git@github.ecs-digital.co.uk/ECSD/playground-frame.git?ref=bugfix/custom_linux_ami//modules/linux_instance"
  count                     = "${var.count}"
  stack_name                = "${local.stack}"
  vpc_id                    = "${module.vpc.vpc_id}"
  subnet_ids                = "${module.vpc.public_subnets}"
  default_security_group_id = "${module.vpc.default_security_group_id}"
  animal_names              = "${module.animal.names}"
  ssh_key_name              = "${local.ssh_key_name}"
  ssh_user                  = "${var.ssh_user}"
  ssh_password              = "${var.ssh_password}"
  custom_install_scripts    = "${data.template_file.linux_install_script.*.rendered}"
  
  instance_type = "t3.large"
}

# This is where the custom install commands are going
# the linux instance is ubuntu, so use apt. Also no need to run apt-get update, it runs earlier in the provisioning
data "template_file" "linux_install_script" {
  count                     = "${var.count}"
  vars {
    ssh_usename = "${var.ssh_user}"
  }

  template = "${file("scripts/install_vnc.sh")}"
}

module "dns" {
  source = "git::ssh://git@github.ecs-digital.co.uk/ECSD/playground-frame.git?ref=v1.0.0//modules/dns"
  animal_names = "${module.animal.names}"
  count = "${var.count}"
  ip_addresses = "${module.linux_instances.ip_addresses}"
  r53_zone_id = "Z2YSGFKC3LJZBA"  
}
