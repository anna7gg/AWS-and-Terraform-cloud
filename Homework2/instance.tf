resource "aws_instance" "web" {
  count = var.web_instances_count
  ami                    = data.aws_ami.latest-ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[count.index].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
  user_data              = local.webserver-instance-userdata
  iam_instance_profile = aws_iam_instance_profile.s3_write_profile.name

  root_block_device {
    volume_size           = var.disk_size
    volume_type           = var.volumes_type
    delete_on_termination = true
  }  

  tags = {
    Name = "webServer-${count.index}-${data.aws_availability_zones.available.names[count.index]}"
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





