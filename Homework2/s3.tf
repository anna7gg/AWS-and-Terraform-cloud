resource "aws_s3_bucket" "nginx_log" {
    acl = var.acl
    bucket = var.bucket_name
    tags = {
    "Name" = var.bucket_name
  }

}