resource "aws_security_group" "web_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "web-sg"
  description = "Allow web traffic, SSH access, and ICMP"

  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group_rule" "web_sg_ingress_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
}

resource "aws_security_group_rule" "web_sg_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = [var.local_ip_range]
}

resource "aws_security_group_rule" "web_sg_ingress_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = [var.local_ip_range]
}

resource "aws_security_group_rule" "web_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "db_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "db-sg"
  description = "Allow database traffic"

  tags = {
    Name = "db-sg"
  }
}

resource "aws_security_group_rule" "db_sg_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.db_sg.id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
}

resource "aws_security_group_rule" "db_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.db_sg.id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
}

resource "aws_security_group" "alb_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "alb-sg"
  description = "Allow HTTP traffic from the internet"

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group_rule" "alb_sg_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
