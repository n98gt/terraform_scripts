# --------------------------------
#
# Creates aws s3-bucket and dynamoDB table for terraform remote state
#
# --------------------------------

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "./../credentials"
  profile                 = var.aws_profile_for_s3_backend
}

terraform {
  backend "s3" {
    shared_credentials_file = "./../credentials"
    encrypt                 = true
  }
}


resource "aws_s3_bucket" "tf_remote_state" {
  bucket = var.s3_bucket_name
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# resource "aws_s3_bucket" "tf_remote_state" {

# }

# locking part
resource "aws_dynamodb_table" "tf_remote_state_locking" {
  hash_key = "LockID"
  name     = var.dynamodb_table_name
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"

}

resource "aws_s3_bucket_public_access_block" "s3_bucket_access_block" {
  bucket = aws_s3_bucket.tf_remote_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
