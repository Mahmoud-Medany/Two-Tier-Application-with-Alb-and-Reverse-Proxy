variable "aws_region" {
  type    = string
  default = "eu-west-1" # تقدر تغيرها لـ us-east-1 أو أي ريجون تحبه
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# هنستخدم Ubuntu 22.04 LTS (تأكد إن الـ AMI ID مطابق للـ Region بتاعتك)
variable "ami_id" {
  type        = string
  default     = "ami-06468be052a4195a6" # Ubuntu 22.04 LTS في eu-west-1
  description = "Ubuntu 22.04 AMI ID"
}