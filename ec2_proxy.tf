# السيرفر الأول في Public Subnet 1
resource "aws_instance" "proxy_1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.proxy.id]

  # تمرير الـ DNS بتاع الـ internal ALB للـ userdata سكريبت ديناميكياً
  user_data = templatefile("${path.module}/nginx_userdata.sh", {
    internal_alb_dns = aws_lb.internal.dns_name
  })

  tags = { Name = "Nginx-Proxy-AZ1" }
}

# السيرفر التاني في Public Subnet 2
resource "aws_instance" "proxy_2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_2.id
  vpc_security_group_ids = [aws_security_group.proxy.id]

  user_data = templatefile("${path.module}/nginx_userdata.sh", {
    internal_alb_dns = aws_lb.internal.dns_name
  })

  tags = { Name = "Nginx-Proxy-AZ2" }
}

# ربط السيرفرات بالـ External Target Group
resource "aws_lb_target_group_attachment" "proxy_1" {
  target_group_arn = aws_lb_target_group.proxy.arn
  target_id        = aws_instance.proxy_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "proxy_2" {
  target_group_arn = aws_lb_target_group.proxy.arn
  target_id        = aws_instance.proxy_2.id
  port             = 80
}