# --------------------------------
#
# Creates EC2-instance wiht Ubuntu 20.04 in aws
#
# --------------------------------

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "./credentials"
}

resource "aws_instance" "server-for-tests" {
  # Ubuntu 20.04
  ami           = "ami-0a49b025fffbbdac6"
  instance_type = "t2.micro"
}


resource "aws_security_group" "server-for-tests" {
  name        = "test-server security group"
  description = "Security group for test-server"

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

  tags = {
    Name  = "Webserver security group"
    Owner = "Roman"
  }
}
