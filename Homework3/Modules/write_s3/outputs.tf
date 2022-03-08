output "bucket" {
  value = aws_s3_bucket.nginx_log
}

output "instance_profile" {
  value = aws_iam_instance_profile.s3_write_profile
}