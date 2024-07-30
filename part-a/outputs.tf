output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "db_instance_address" {
  description = "The address of the RDS instance."
  value       = module.rds.db_instance_address
}

output "db_password" {
  value     = random_string.db_password.result
  sensitive = true
}

output "ec2_instance_public_ip" {
  description = "The public IP of the EC2 instance."
  value       = aws_instance.web.public_ip
}

output "ec2_instance_public_dns" {
  description = "The public DNS of the EC2 instance."
  value       = aws_instance.web.public_dns
}