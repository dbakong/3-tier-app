variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "local_ip_range" {
  description = "Your local IP range to allow SSH access"
  type        = string
}

variable "db_name" {
  description = "The name of the database."
  type        = string
  default     = "testdatabase"
}

variable "db_username" {
  description = "The username for the database."
  type        = string
  default     = "testuser"
}

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
  default     = "ami-01b64707e9d9b7350"
}

variable "instance_type" {
  description = "The instance type to use for the instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use for the instances"
  type        = string
}
