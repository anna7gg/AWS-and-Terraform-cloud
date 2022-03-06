resource "aws_instance" "DB_instances" {
  count                       = var.DB_instances_count
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private.*.id[count.index]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.db_security_group.id]

  tags = {
    "Name" = "DB-${data.aws_availability_zones.available.names[count.index]}"
  }
}


