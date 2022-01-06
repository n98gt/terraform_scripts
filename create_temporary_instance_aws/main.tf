# --------------------------------
#
# Creates EC2 instance with VPC,subnet,traffic rules
#
# --------------------------------

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "./credentials"
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

resource "aws_vpc" "vpc_for_test-server" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = var.vpc_tags
}

resource "aws_subnet" "subnet_for_test-server" {
  vpc_id                  = aws_vpc.vpc_for_test-server.id
  cidr_block              = var.subnet_info.cidr_block
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.subnet_info.name
  }

}

# create gateway
resource "aws_internet_gateway" "gateway_for_test-server" {
  vpc_id = aws_vpc.vpc_for_test-server.id

  tags = var.gateway_tags

}

resource "aws_route_table" "route-table_for_test-server" {
  vpc_id = aws_vpc.vpc_for_test-server.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_for_test-server.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gateway_for_test-server.id
  }

  tags = var.route_table_tags
}

resource "aws_route_table_association" "assoc-1" {
  subnet_id      = aws_subnet.subnet_for_test-server.id
  route_table_id = aws_route_table.route-table_for_test-server.id
}

resource "aws_network_interface" "network-interface_for_test-server" {
  subnet_id   = aws_subnet.subnet_for_test-server.id
  private_ips = [var.private_ip]

  security_groups = [aws_security_group.security-group_for_test-server.id]
}



resource "aws_security_group" "security-group_for_test-server" {
  name        = "test-server security group"
  description = "Security group for test-server"
  vpc_id      = aws_vpc.vpc_for_test-server.id

  ingress = [
    {
      description      = "allow http traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "allow https traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
    , {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  egress {
    description      = "allow all traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "null_resource" "generate_ssh_config" {
  triggers = {
    server_public_ip = aws_instance.test-server.public_ip
  }
  provisioner "local-exec" {
    command = "bash generate_ssh_config_with_public_ip.sh ${aws_instance.test-server.public_ip} ${var.ssh_config_path}"
  }
}
