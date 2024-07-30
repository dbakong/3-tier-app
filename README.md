# Multi-Instance Web Application with Database
## Introduction
This project demonstrates the deployment of a multi-instance web application with a database. The setup is divided into two parts:

1. [Part A: Single server with a small database.](https://github.com/dbakong/test-web-app/tree/main/part-a)
2. [Part B: Scalable architecture with five servers, a medium-sized database, and a load balancer.](https://github.com/dbakong/test-web-app/tree/main/part-b)

### Setup and Deployment Steps

-  Clone the Repository:
    ``` bash 
    git clone https://github.com/dbakong/test-web-app.git
    ```
- Create project dependencies
    ``` bash
    make setup
    ```

- Change to the desired directory
    ``` bash
    cd test-web-app/part-a
    # or 
    cd test-web-app/part-b
    ```

- Create a terraform execution plan
    ```bash
    make plan
    ```

- Build AWS infrastructure:
    ```bash
    make apply
    ```

- Get testing instructions
    ```bash
    make test
    ```
    see 

### Assumptions
- You have the AWS CLI installed and configured to access an AWS account
- The IAM role you are using has the necessary permissions to create and manage the resources specified in this project, including EC2 instances, RDS databases, and other infrastructure components.

### Project Dependencies
1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
3. [GNU Make](https://www.gnu.org/software/make/)

### Security Considerations
- Ensure your AWS credentials are secure.
- Use IAM roles with the minimum required permissions.
- Manage secrets securely, avoiding hardcoding sensitive information.

### Troubleshooting
Some useful resources for troubleshooting common issues:
- [AWS EC2 troubleshooting guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-troubleshoot.html)
- [AWS VPC troubleshooting guide](https://repost.aws/knowledge-center/instance-vpc-troubleshoot)
- [Terraform troubleshooting guide](https://developer.hashicorp.com/terraform/tutorials/configuration-language/troubleshooting-workflow)


## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details