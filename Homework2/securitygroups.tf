
resource "aws_security_group" "alb_security_group" {
    name = "alb_security_group"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
    	cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
    	cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
      }
    tags = {
        Name = "alb_security_group"
    }
}

resource "aws_security_group" "webserver_security_group" {
    name = "webserver_security_group"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
    	security_groups = [aws_security_group.alb_security_group.id]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
    	cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
    	security_groups = [aws_security_group.alb_security_group.id]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
     #   ipv6_cidr_blocks = ["::/0"]
      }
    tags = {
        Name = "webserver_security_group"
    }
}

resource "aws_security_group" "db_security_group" {
    name = "db_security_group"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
        security_groups = [aws_security_group.webserver_security_group.id]
    }
    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.webserver_security_group.id]

    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
    	cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
      }
        tags = {
        Name = "db_security_group"
    }
}

