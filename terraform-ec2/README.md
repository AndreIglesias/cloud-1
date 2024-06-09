# Terraform AWS WordPress Deployment

This Terraform configuration sets up an AWS EC2 instance with the necessary security group to host a WordPress server. The instance is configured to allow SSH and HTTPS traffic, and it installs basic software upon provisioning.

## Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- AWS credentials configured on your local machine
- An SSH key pair for connecting to your EC2 instance

### Setup AWS CLI

To configure your AWS CLI with access keys, run the following command:

```bash
aws configure
```

For more details on creating and using access keys, refer to the [AWS documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).

## Configuration Details

### Provider

The configuration uses the AWS provider and is set to the `eu-west-3` region.

### Security Group

A security group named `wordpress_sg` is created to allow:
- SSH traffic on port 22 from any IP address.
- HTTPS traffic on port 443 from any IP address.
- All outbound traffic.

### EC2 Instance

An EC2 instance is created with the following specifications:
- **AMI**: Ubuntu 22.04 LTS
- **Instance Type**: `t2.micro`
- **Key Name**: `cloud-key` (Ensure this key exists in your AWS account)
- **Root Block Device**: 8 GiB
- **Security Group**: The instance is associated with the `wordpress_sg` security group.
- **Tags**: The instance is tagged with `Name: WordPress-Server`

### Provisioning

The instance is provisioned to:
- Update the package list.

### Outputs

The configuration outputs the public IP of the WordPress server instance.

## Usage

### Step 1: Initialize Terraform

Navigate to the directory containing the Terraform configuration files and run the following command to initialize Terraform:

```sh
terraform init
```

### Step 2: Apply the Configuration

Run the following command to create the resources defined in the configuration:

```sh
terraform apply
```

You will be prompted to confirm the apply. Type `yes` and press Enter.

### Step 3: Access Your Instance

After the apply is complete, Terraform will output the public IP of the WordPress server. Use this IP to SSH into your instance:

```sh
ssh -i ~/.ssh/cloud-key.pem ubuntu@<instance_ip>
```

Replace `<instance_ip>` with the public IP provided in the Terraform output.

## Cleaning Up

To destroy the resources created by this configuration, run the following command:

```sh
terraform destroy
```

You will be prompted to confirm the destroy. Type `yes` and press Enter.

## Notes

- Ensure your SSH private key (`cloud-key.pem`) is located in the `~/.ssh/` directory and has the correct permissions (`chmod 400 ~/.ssh/cloud-key.pem`).
- Modify the Terraform configuration as needed to fit your specific requirements.
