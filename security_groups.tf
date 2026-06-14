# 1. External ALB Security Group
resource "aws_security_group" "ext_alb" {
  name        = "external-alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow public HTTP traffic to External ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Proxy EC2 Security Group
resource "aws_security_group" "proxy" {
  name        = "proxy-ec2-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow traffic from External ALB only"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ext_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Internal ALB Security Group
resource "aws_security_group" "int_alb" {
  name        = "internal-alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow traffic from Proxy EC2 instances"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Backend EC2 (Apache) Security Group
resource "aws_security_group" "backend" {
  name        = "backend-ec2-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow traffic from Internal ALB only"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.int_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}