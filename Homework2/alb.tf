resource "aws_alb" "web-alb" {
  name = "app-alb-${aws_vpc.main.id}"
  load_balancer_type = "application"
  dynamic "subnet_mapping" {
    for_each = aws_subnet.public.*.id
    content {
      subnet_id = subnet_mapping.value
    }
  }
  security_groups = [aws_security_group.webserver_security_group.id]
  tags = {
    Name = "app_alb ${aws_vpc.main.id}"
  }
}

resource "aws_alb_target_group" "web-group" {
  name = "alb-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "instance"
  health_check {
   enabled = true
    path = "/"
  }
    tags = {
    "Name" = "web-target-group-${aws_vpc.main.id}"
  }
  stickiness {
    type = "lb_cookie"
    cookie_duration = 60
  }
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_alb.web-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.web-group.arn
  }
}

resource "aws_alb_target_group_attachment" "web_server" {
  count            = length(aws_instance.web)
  target_group_arn = aws_alb_target_group.web-group.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
