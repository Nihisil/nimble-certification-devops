resource "aws_security_group" "alb" {
  name        = "${var.namespace}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.namespace}-alb-sg"
  }
}

resource "aws_security_group" "ecs_fargate" {
  name        = "${var.namespace}-ecs-fargate-sg"
  description = "ECS Fargate Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.namespace}-ecs-fargate-sg"
  }
}

resource "aws_security_group_rule" "ecs_fargate_ingress_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_fargate.id
  protocol                 = "tcp"
  from_port                = var.app_port
  to_port                  = var.app_port
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs_fargate_ingress_private" {
  type              = "ingress"
  security_group_id = aws_security_group.ecs_fargate.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = var.private_subnets_cidr_blocks
}

resource "aws_security_group_rule" "ecs_fargate_egress_anywhere" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_fargate.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
