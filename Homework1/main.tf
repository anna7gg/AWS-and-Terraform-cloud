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

resource "aws_instance" "Whiskey1" {
  ami           = "ami-04505e74c0741db8d"
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
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t3.micro"
user_data     = <<EOT
#cloud-config
package_update: true
packages:
- nginx
write_files:
- content: |
    <!DOCTYPE html>
    <html>
    <head>
      <title>Grandpa's Whiskey</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    </head>
    <body>
      <p>Welcome to Grandpa's Whiskey</p>
    </body>
    </html>
  path: /var/www/html/index.html
  permissions: '0644'
EOT
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
    Name = "whiskyTwo"
    owner= "Grandpa"
    purpose= "sell"
  }  
}
