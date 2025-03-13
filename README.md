# Terraform AWS Infrastructure Project

This project uses Terraform to provision and manage AWS infrastructure, including a Virtual Private Cloud (VPC) with public and private subnets, a bastion server, an NGINX server, and a web server.

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
  - **Bastion Server**: Acts as a gateway to access other instances in the private subnet.
  - **NGINX Server**: Hosts an NGINX web server.
  - **Web Server**: A general-purpose server running on CentOS.

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