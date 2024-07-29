variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "local_ip_range" {
  description = "The IP range to allow SSH access from."
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
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
  default     = "ami-01b64707e9d9b7350"
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the instance."
  type        = string
  default     = "testKeyPair"
}
