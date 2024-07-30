output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "The IDs of the public subnets."
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The IDs of the private subnets."
  value       = module.vpc.private_subnets
}

output "db_instance_address" {
  description = "The address of the RDS instance."
  value       = module.rds.db_instance_address
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.app_lb.dns_name
}

output "web_asg_name" {
  description = "The name of the web application Auto Scaling Group."
  value       = aws_autoscaling_group.web_asg.name
}

output "app_lb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.app_lb.dns_name
}