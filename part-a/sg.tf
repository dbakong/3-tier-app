resource "aws_security_group" "web_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "web-sg"
  description = "Allow web traffic and SSH access"

  tags = {
    project = "part-a"
  }
}

resource "aws_security_group_rule" "web_sg_ingress_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
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
    Name    = "db-sg"
    project = "part-a"
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
