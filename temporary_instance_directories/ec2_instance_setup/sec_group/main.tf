# --------------------------------
#
# Creates security group
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

resource "aws_security_group" "security-group_for_test-server" {
  name        = "test-server security group"
  description = "Security group for test-server"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

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
    , {
      description      = "allow jenkins traffic"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
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
