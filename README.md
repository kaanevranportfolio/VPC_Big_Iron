# Terraform AWS Infrastructure Project

This project uses Terraform to provision and manage AWS infrastructure, including a Virtual Private Cloud (VPC) with public and private subnets, a bastion server, an NGINX server, and a web server.


## Project Aim

Create a web infrastructure, where Nginx act as a load balancer directing traffic to web server, which is in 
a private subnet and communicates to public internet through NAT Gateway. The infrastructure setup is achieved with 
Terraform, which also creates inventory file (which references the IP addresses yet to be created)
for **Ansible** using template. Then control server provisions the servers, using Ansible roles and templates, tasks 
and handlers. **Master** branch is the setup of Infrastructure. **Combined** branch is the provisioning servers 
with combined action of Terraform ans Ansible.

## Project Overview

The Terraform configuration in this project sets up the following AWS resources:

- **VPC (Virtual Private Cloud)**: A custom VPC named "BigIronVPC" with DNS support and hostnames enabled.
- **Subnets**: 
  - **Public Subnet**: For resources that need direct access to the internet.
  - **Private Subnet**: For resources that do not require direct internet access.
- **Internet Gateway**: Allows internet access for resources in the public subnet.
- **NAT Gateway**: Provides internet access for resources in the private subnet.
- **Route Tables**: Configured for both public and private subnets to manage traffic routing.
- **EC2 Instances**:
  - **Bastion Server**: Acts as a gateway to access other instances in the private subnet (**Ubuntu**).
  - **NGINX Server**: Hosts an NGINX web server (**Ubuntu**).
  - **Web Server**: A general-purpose server (**CentOS**).
  - **Control Server**: A general-purpose server running **Ansible** (**Amazon Linux** which is based on CenOS).
 

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An AWS account with appropriate permissions to create VPCs, subnets, EC2 instances, security groups, and other resources.
- AWS CLI configured with your credentials.
- SSH key pairs for accessing the instances.

## Installation

1. **Clone the repository**:
```bash
    git clone https://github.com/yourusername/your-repo-name.git
    cd your-repo-name
```

## Starting the Terraform Project

1. **Initialize Terraform**:
    ```bash
    terraform init
    ```

2. **Plan the Infrastructure**:
    ```bash
    terraform plan
    ```

3. **Apply the Configuration**:
    ```bash
    terraform apply
    ```

## Destroying the Terraform Project

1. **Destroy the Infrastructure**:
    ```bash
    terraform destroy
    ```
