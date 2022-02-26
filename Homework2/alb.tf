resource "aws_alb" "alb" {
  name = "app-alb"
  dynamic "subnet_mapping" {
    for_each = aws_subnet.public.*.id
    content {
      subnet_id = subnet_mapping.value
    }
  }
  security_groups = [aws_security_group.alb_security_group.id]
  tags = {
    Name = "app_alb"
  }
}

resource "aws_alb_target_group" "group" {
  name = "alb-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "instance"
  health_check {
    path = "/"
    port = "80"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.group.arn
  }
}

resource "aws_alb_target_group_attachment" "http" {
  count = 2
  target_group_arn = aws_alb_target_group.group.arn
  target_id        = aws_instance.web[count.index].id
}
