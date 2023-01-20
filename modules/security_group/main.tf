resource "aws_security_group" "alb" {
  name        = "${var.namespace}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.namespace}-alb-sg"
  }
}
