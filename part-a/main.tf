provider "aws" {
  region = var.aws_region
}

provider "random" {}


locals {
  public_subnet_cidrs  = [cidrsubnet(var.vpc_cidr, 8, 1)]
  private_subnet_cidrs = [cidrsubnet(var.vpc_cidr, 8, 3), cidrsubnet(var.vpc_cidr, 8, 4)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name = "main-vpc"
  cidr = var.vpc_cidr

  azs                     = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets          = local.public_subnet_cidrs
  private_subnets         = local.private_subnet_cidrs
  map_public_ip_on_launch = true
  enable_nat_gateway      = false

  tags = {
    project = "part-a"
  }
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
  instance_class        = "db.t3.micro"
  allocated_storage     = 10
  max_allocated_storage = 1024

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

  tags = {
    project = "part-a"
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    project = "part-a"
  }

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    db_username = var.db_username,
    db_password = random_string.db_password.result,
    db_host     = module.rds.db_instance_address,
    db_name     = var.db_name
  })
}
