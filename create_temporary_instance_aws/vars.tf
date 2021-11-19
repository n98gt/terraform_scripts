variable "image_name" {
  type    = string
  default = "ami-083654bd07b5da81d"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_key_name" {
  type    = string
  default = "ec2-ssh-key"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_tags" {
  type = object({
    Name = string
  })
  default = {
    Name = "test-server"
  }
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/24"
}

variable "vpc_tags" {
  type = object({
    Name = string
  })
  default = {
    Name = "virtual network for test server"
  }
}

variable "subnet_info" {
  type = object({
    cidr_block = string,
    name       = string
  })
  default = {
    cidr_block = "10.0.0.0/28", # smallest allowed subnet (16 IP with reserver first 4 and last 4 addresses)
    name       = "subnet for test-server"
  }
}

variable "private_ip" {
  type    = string
  default = "10.0.0.4"
}

variable "gateway_tags" {
  type = object({
    Name = string
  })
  default = {
    Name = "gateway for test server"
  }
}


variable "route_table_tags" {
  type = object({
    Name = string
  })
  default = {
    Name = "route_table for test server"
  }
}
