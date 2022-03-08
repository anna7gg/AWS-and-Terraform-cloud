data "aws_ami" "latest-whisky" {
most_recent = true
owners = ["self"]
name_regex = "nginx-whisky"
}

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}