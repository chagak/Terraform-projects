🌐 Dynamic Website Deployment on AWS with Terraform

📄 Project Overview

This project automates the deployment of a secure, scalable dynamic website on AWS using Terraform.It provisions a complete infrastructure stack including EC2 instances behind a Load Balancer, an Auto Scaling Group, a managed RDS database, VPC with NAT Gateway, SNS notifications, secure networking, a custom domain name via Route 53, and HTTPS encryption using ACM.

🚀 Technologies Used

Terraform – Infrastructure as Code (IaC)

AWS Services:

EC2 (Elastic Compute Cloud) — Application Servers

RDS (Relational Database Service) — Managed Database

ALB (Application Load Balancer) — Traffic Distribution

Auto Scaling Group (ASG) — Automatic scaling of EC2 instances

Route 53 — DNS Management

ACM (AWS Certificate Manager) — SSL/TLS Certificates

VPC (Virtual Private Cloud) with NAT Gateway — Secure networking

SNS (Simple Notification Service) — Notifications and Alerts

VPC, Subnets, Security Groups, IAM Roles

⚙️ Prerequisites

Terraform installed

AWS CLI installed and configured

An AWS account with sufficient permissions to create:

EC2, Auto Scaling Groups, RDS, ALB, VPC, NAT Gateway, Route53, ACM, SNS

A registered domain name (managed in Route 53)

🚀 How to Deploy

Clone the Repository

git clone https://github.com/chagak/Terraform-projects.git
cd Terraform-projects/dynamic-website

Customize Variables
Edit terraform.tfvars to set:

AWS region

EC2 instance details

Auto Scaling settings

RDS database settings

VPC and NAT Gateway configuration

SNS Topic settings

Domain name for Route53

ACM Certificate ARN (or let Terraform request it)

Initialize Terraform

terraform init

Review the Terraform Plan

terraform plan

Apply the Infrastructure

terraform apply

Confirm with yes when prompted.

Access the Website

Once deployment is complete, Terraform will output the website domain name.

Open your browser and access your dynamic website securely over HTTPS.

🧹 Clean Up (Resource Deletion)

To avoid unnecessary AWS charges, destroy all resources when no longer needed:

terraform destroy

📌 Key Features

Highly Available Setup: EC2 instances behind an ALB with Auto Scaling Group.

Secure Access: HTTPS enabled via ACM.

Scalable Database: Managed RDS instance.

Custom Domain: DNS configured automatically with Route 53.

Private Networking: VPC with NAT Gateway for secure Internet access.

Event Notifications: Alerts via SNS Topics.

Infrastructure as Code: Reproducible and manageable deployments.

🛠️ Configuration Tips

Ensure security groups allow:

ALB inbound HTTP/HTTPS (ports 80, 443)

EC2 inbound traffic only from ALB

RDS inbound traffic only from EC2 private IPs

Use private subnets for the database for better security.

NAT Gateway should be placed in a public subnet.

Configure Auto Scaling Group policies to automatically adjust to load.

Regularly rotate and manage your RDS credentials securely.

Set up SNS notifications for important Auto Scaling or resource alerts.


