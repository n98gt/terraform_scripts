# --------------------------------
#
# Creates EC2 instance
#
# --------------------------------

terraform {
  backend "s3" {
    shared_credentials_file = "./../../credentials"
    encrypt                 = true
  }
}

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "./../../credentials"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket                  = var.s3_backend_bucket_name
    key                     = var.s3_backend_vpc_tfstate_path
    region                  = var.s3_backend_aws_region
    profile                 = var.s3_backend_profile
    shared_credentials_file = "./../../credentials"
    encrypt                 = true
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket                  = var.s3_backend_bucket_name
    key                     = var.s3_backend_security_group_tfstate_path
    region                  = var.s3_backend_aws_region
    profile                 = var.s3_backend_profile
    shared_credentials_file = "./../../credentials"
    encrypt                 = true
  }
}




resource "aws_instance" "test-server" {
  ami           = var.image_name
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.network-interface_for_test-server.id
  }

  tags = var.instance_tags
}

resource "aws_network_interface" "network-interface_for_test-server" {
  subnet_id   = data.terraform_remote_state.vpc.outputs.subnet_id
  private_ips = [var.private_ip]

  security_groups = [data.terraform_remote_state.security_group.outputs.sec_group_id]
}

resource "aws_key_pair" "ssh_public_key" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "null_resource" "generate_ssh_config" {
  triggers = {
    server_public_ip = aws_instance.test-server.public_ip
  }
  provisioner "local-exec" {
    command = "bash generate_ssh_config_with_public_ip.sh ${aws_instance.test-server.public_ip} ${var.ssh_config_path}"
  }
}

resource "null_resource" "check_server_readiness_for_connection" {
  triggers = {
    server_public_ip = aws_instance.test-server.public_ip
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait for SSH connection'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = aws_instance.test-server.public_ip
      agent       = false
    }
  }
}
