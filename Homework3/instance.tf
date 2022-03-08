resource "aws_instance" "web" {
  count = var.web_instances_count
  ami                    = data.aws_ami.latest-ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets_id[count.index]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
  user_data              = local.webserver-instance-userdata
  iam_instance_profile = module.bucket.instance_profile.name

  root_block_device {
    volume_size           = var.disk_size
    volume_type           = var.volumes_type
    delete_on_termination = true
  }  

  tags = {
    Name = "webServer-${count.index}-${data.aws_availability_zones.available.names[count.index]}"
    }
}
###### db
resource "aws_instance" "DB_instances" {
  count                       = "${var.DB_instances_count}"
  ami                         = "${data.aws_ami.latest-ubuntu.id}"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.private_subnets_id[count.index]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.db_security_group.id]

  tags = {
    "Name" = "DB-${data.aws_availability_zones.available.names[count.index]}"
  }
}
##### volume
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

#### security group

resource "aws_security_group" "webserver_security_group" {
      name = "webserver_security_group"
      vpc_id = module.vpc.vpc_id
      tags = {
          Name = "webserver_security_group ${module.vpc.vpc_id}"
      }
}

resource "aws_security_group_rule" "webserver_http_acess" {
    description       = "allow http access from anywhere"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.webserver_security_group.id
    to_port           = 80
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "webserver_ssh_acess" {
    description       = "allow ssh access from anywhere"
    from_port         = 22
    protocol          = "tcp"
    security_group_id = aws_security_group.webserver_security_group.id
    to_port           = 22
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "webserver_outbound_anywhere" {
    description       = "allow outbound traffic to anywhere"
    from_port         = 0
    protocol          = "-1"
    security_group_id = aws_security_group.webserver_security_group.id
    to_port           = 0
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "db_security_group" {
    name = "db_security_group"
    vpc_id = module.vpc.vpc_id
        tags = {
        Name = "db_security_group ${module.vpc.vpc_id}"
    }
}


resource "aws_security_group_rule" "DB_ssh_acess" {
    description       = "allow ssh access from anywhere"
    from_port         = 22
    protocol          = "tcp"
    security_group_id = aws_security_group.db_security_group.id
    to_port           = 22
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "DB_outbound_anywhere" {
    description       = "allow outbound traffic to anywhere"
    from_port         = 0
    protocol          = "-1"
    security_group_id = aws_security_group.db_security_group.id
    to_port           = 0
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]

}






