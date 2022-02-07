# --------------------------------
#
# Creates VPC,subnet,traffic rules
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
