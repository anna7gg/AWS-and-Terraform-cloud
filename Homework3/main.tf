# S3 bucket config
module "bucket" {
  bucket_name = var.bucket_name
  source = ".//Modules//write_s3"
  acl = var.acl
}

module "vpc" {
  source = ".//Modules//vpc"
  private_subnet = var.private_subnet
  public_subnet = var.public_subnet
  vpc_cidr_block = var.vpc_cidr_block
}