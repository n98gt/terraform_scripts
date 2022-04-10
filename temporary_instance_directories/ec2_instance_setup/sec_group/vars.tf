variable "aws_region" {
  type    = string
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
