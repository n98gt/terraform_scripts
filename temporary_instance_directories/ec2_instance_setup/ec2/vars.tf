variable "image_name" {
  type    = string
  default = "ami-0fb653ca2d3203ac1" # Ubuntu20.04
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_key_name" {
  type    = string
  default = "ec2-ssh-key"
}

variable "ssh_public_key" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-2" # us-east-2 Ohio
}

variable "instance_tags" {
  type = object({
    Name = string
  })
  default = {
    Name = "test-server"
  }
}
variable "private_ip" {
  type    = string
  default = "10.0.0.4"
}

variable "s3_backend_aws_region" {
  type    = string
  default = "eu-north-1" # eu-north-1 Stockholm
}

variable "s3_backend_profile" {
  type = string
}

variable "s3_backend_bucket_name" {
  type = string
}

variable "s3_backend_vpc_tfstate_path" {
  type = string
}

variable "s3_backend_security_group_tfstate_path" {
  type = string
}

variable "ssh_config_path" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}
