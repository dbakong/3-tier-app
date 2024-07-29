TF_ENV ?= dev
AWS_REGION ?= us-east-2
KEY_NAME ?= testKeyPair
PORT ?= 8080
EC2_IP = $(shell terraform output -raw ec2_instance_public_ip)
DB_ENDPOINT = $(shell terraform output -raw db_instance_address)
LOCAL_IP = $(shell curl -4 ifconfig.me)

export AWS_REGION

.PHONY: plan apply destroy output test

setup:
	@echo "Creating key pair if it doesn't exist..."
	@[ -f "testKeyPair.pem" ] && echo "testKeyPair.pem exists" || \
	(aws ec2 create-key-pair --key-name testKeyPair --query 'KeyMaterial' --output text > testKeyPair.pem 
	@echo "Modifying permissions of key pair file..."
	chmod 400 testKeyPair.pem && echo "Key pair testKeyPair created and saved to testKeyPair.pem.")

plan:
	@echo "Running pre-plan steps (init, fmt, validate) and plan..."
	terraform init
	terraform fmt
	terraform validate
	terraform plan -var "local_ip_range=${LOCAL_IP}/32"

apply:
	@echo "Applying Terraform changes..."
	terraform apply -var "local_ip_range=${LOCAL_IP}/32" -auto-approve

destroy:
	@echo "Destroying Terraform-managed infrastructure..."
	terraform destroy -var "local_ip_range=${LOCAL_IP}/32" -auto-approve

output:
	@echo "Retrieving Terraform outputs..."
	terraform output

test:
	@echo "Checking if EC2 instance can access RDS instance..."
	ssh -i $(KEY_NAME).pem ec2-user@$(EC2_IP) \
	'nc -zv $(DB_ENDPOINT) 3306 && echo "Success: EC2 instance has access to the RDS instance." \
	|| echo "Error: EC2 instance cannot connect to the RDS instance."'
	@echo "Checking if server is running on port 80"
	curl -I http://$(EC2_IP):8080
