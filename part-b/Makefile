TF_ENV ?= dev
AWS_REGION ?= us-east-2
KEY_NAME ?= testKeyPair1
PORT ?= 8080
ALB_DNS_NAME = $(shell terraform output -raw alb_dns_name)
DB_ENDPOINT = $(shell terraform output -raw db_instance_address)
LOCAL_IP = $(shell curl -4 ifconfig.me)
KEY_PAIR_ID = $(shell aws ec2 describe-key-pairs --region $(AWS_REGION) --no-cli-pager --query "KeyPairs[?KeyName=='$(KEY_NAME)'].KeyPairId" --output text)

export AWS_REGION

.PHONY: setup plan apply destroy output test clean

create_key_pair:
	aws ec2 create-key-pair --key-name $(KEY_NAME) --query 'KeyMaterial' --output text > $(KEY_NAME).pem
	chmod 400 $(KEY_NAME).pem

delete_key_pair:
	if [ -n "$(KEY_PAIR_ID)" ]; then \
		aws ec2 delete-key-pair --key-pair-id $(KEY_PAIR_ID) --region $(AWS_REGION) --no-cli-pager; \
		echo "Key pair deleted successfully."; \
	else \
		echo "Key pair not found on AWS."; \
	fi

setup: clean
	@echo "Setting up..."
	if [ -z "$(KEY_PAIR_ID)" ]; then \
		make create_key_pair; \
		echo "Key pair created and file permissions set."; \
	else \
		echo "Key pair already exists."; \
	fi

plan:
	@echo "Running pre-plan steps (init, fmt, validate) and plan..."
	terraform init
	terraform fmt
	terraform validate
	terraform plan -var "local_ip_range=${LOCAL_IP}/32" -var "aws_region=${AWS_REGION}" -var "key_name=${KEY_NAME}"

apply:
	@echo "Applying Terraform changes..."
	terraform apply -var "local_ip_range=${LOCAL_IP}/32" -var "aws_region=${AWS_REGION}" -var "key_name=${KEY_NAME}" -auto-approve

destroy: clean
	@echo "Destroying Terraform-managed infrastructure..."
	terraform destroy -var "local_ip_range=${LOCAL_IP}/32" -var "aws_region=${AWS_REGION}" -var "key_name=${KEY_NAME}" -auto-approve

output:
	@echo "Retrieving Terraform outputs..."
	terraform output

test:
	@echo "You might need to wait for a few minutes for the application to be up and running."
	@echo "You can test the application by visiting:"
	@echo "  http://$(ALB_DNS_NAME):$(PORT)"


clean:
	@echo "Cleaning up..."
	make delete_key_pair
	@rm -f $(KEY_NAME).pem
