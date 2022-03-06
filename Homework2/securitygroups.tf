
resource "aws_security_group" "webserver_security_group" {
      name = "webserver_security_group"
      vpc_id = aws_vpc.main.id
      tags = {
          Name = "webserver_security_group ${aws_vpc.main.id}"
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
    vpc_id = aws_vpc.main.id
        tags = {
        Name = "db_security_group ${aws_vpc.main.id}"
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

