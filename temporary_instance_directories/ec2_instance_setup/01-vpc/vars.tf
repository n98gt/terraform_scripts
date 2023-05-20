variable "aws_region" {
  type    = string
  default = "us-east-2"
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
