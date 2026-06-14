# سيرفر الـ Apache الأول في Private Subnet 1
resource "aws_instance" "backend_1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.backend.id]
  user_data              = file("${path.module}/apache_userdata.sh")

  tags = { Name = "Apache-Backend-AZ1" }
}

# سيرفر الـ Apache التاني في Private Subnet 2
resource "aws_instance" "backend_2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_2.id
  vpc_security_group_ids = [aws_security_group.backend.id]
  user_data              = file("${path.module}/apache_userdata.sh")

  tags = { Name = "Apache-Backend-AZ2" }
}

# ربط السيرفرات بالـ Internal Target Group
resource "aws_lb_target_group_attachment" "backend_1" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = aws_instance.backend_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend_2" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = aws_instance.backend_2.id
  port             = 80
}