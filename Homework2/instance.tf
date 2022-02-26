data "aws_ami" "latest-whisky" {
most_recent = true
owners = ["self"]
name_regex = "nginx-whisky"
}

resource "aws_instance" "web" {
  count = 2
  ami           = data.aws_ami.latest-whisky.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public[count.index].id
  key_name= "whiskey"
  vpc_security_group_ids = ["${aws_security_group.webserver_security_group.id}"]

  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    delete_on_termination = true
  }  

  tags = {
    Name = "webServer-${count.index}"
    owner = "Grandpa"
    purpose = "sell_whisky"
    }
}

resource "aws_volume_attachment" "ebs_att" {
  count = 2
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.non_root[count.index].id
  instance_id = aws_instance.web[count.index].id
}

resource "aws_ebs_volume" "non_root" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  size = 10
  encrypted = true
}

