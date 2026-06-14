resource "aws_lb" "internal" {
  name               = "int-alb"
  internal           = true # انترنال!
  load_balancer_type = "application"
  security_groups    = [aws_security_group.int_alb.id]
  subnets            = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = { Name = "Internal-ALB" }
}

resource "aws_lb_target_group" "backend" {
  name     = "backend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}