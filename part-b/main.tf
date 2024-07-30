provider "aws" {
  region = var.aws_region
}

provider "random" {}

locals {
  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 1),
    cidrsubnet(var.vpc_cidr, 8, 2)
  ]

  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 3),
    cidrsubnet(var.vpc_cidr, 8, 4)
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name = "main-vpc"
  cidr = var.vpc_cidr

  azs                  = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets       = local.public_subnet_cidrs
  private_subnets      = local.private_subnet_cidrs
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "random_string" "db_password" {
  length  = 16
  special = false
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.3.0"

  identifier            = "demodb"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.medium"
  allocated_storage     = 20
  max_allocated_storage = 5120

  db_name  = var.db_name
  username = var.db_username
  password = random_string.db_password.result
  port     = 3306

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  subnet_ids             = module.vpc.private_subnets
  multi_az               = true
  create_db_subnet_group = true


  create_db_parameter_group = false
  create_db_option_group    = false
  publicly_accessible       = false
  skip_final_snapshot       = true
  deletion_protection       = false
}

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    project = "web"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    project = "web"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_launch_configuration" "web_lc" {
  name            = "web-lc"
  image_id        = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.web_sg.id]

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    db_username = var.db_username,
    db_password = random_string.db_password.result,
    db_host     = module.rds.db_instance_address,
    db_name     = var.db_name
  })
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity          = 5
  max_size                  = 5
  min_size                  = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns         = [aws_lb_target_group.web_tg.arn]
  launch_configuration      = aws_launch_configuration.web_lc.id
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
