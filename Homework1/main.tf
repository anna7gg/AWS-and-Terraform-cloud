terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
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

resource "aws_instance" "Whiskey1" {
  ami           = "${data.aws_ami.latest-ubuntu.id}"
  instance_type = "t3.micro"
  user_data="${file("install_nginx.sh")}"
  vpc_security_group_ids = ["${aws_security_group.webserver_security_group.id}"]

  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }  

  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  
  tags = {
    Name = "whiskyOne"
    owner = "Grandpa"
    purpose = "buy"  
    }
}


resource "aws_instance" "Whiskey2" {
  ami           = "${data.aws_ami.latest-ubuntu.id}"
  instance_type = "t3.micro"
  user_data="${file("install_nginx.sh")}"
  vpc_security_group_ids = ["${aws_security_group.webserver_security_group.id}"]
  availability_zone = "us-east-1f"

  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = false
  }  

  tags = {
    Name = "whiskyTwo"
    owner= "Grandpa"
    purpose= "sell"
  }  
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.non_root.id
  instance_id = aws_instance.Whiskey2.id
}

resource "aws_ebs_volume" "non_root" {
  availability_zone = "us-east-1f"
  size = 10
  encrypted = true
}
