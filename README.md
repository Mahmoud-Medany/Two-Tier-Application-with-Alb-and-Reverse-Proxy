# Highly Available Multi-Tier Web Architecture with Terraform

This repository contains the Infrastructure as Code (IaC) files to deploy a highly available, secure, and load-balanced multi-tier web application on AWS using **Terraform**.

## 📌 Architecture Overview

The infrastructure is designed with a zero-trust network approach across two Availability Zones (AZs) for high availability and fault tolerance.

* **VPC (`10.0.0.0/16`):** Divided into 2 Public Subnets and 2 Private Subnets across 2 AZs.
* **Public Tier (Ingress):** * An **Internet-facing External Application Load Balancer (ALB)** that receives public traffic.
    * Two **EC2 Instances** acting as **Nginx Reverse Proxies** to intercept traffic and route it internally.
* **Private Tier (App/Backend):**
    * An **Internal Application Load Balancer (ALB)** that safely forwards requests from the Nginx tier to the web servers.
    * Two **EC2 Instances** running **Apache2 Web Servers** isolated from direct internet access.
* **Internet Connectivity:** An **Internet Gateway (IGW)** for public subnets, and a **NAT Gateway** to allow private Apache instances to securely download packages (like updates and Apache itself) without exposing them to the internet.

---

## 🔄 Traffic Flow

1.  **User** hits the **External ALB URL**.
2.  **External ALB** forwards the request to the **Nginx Proxy instances** in the Public Subnets.
3.  **Nginx** acts as a reverse proxy and passes the request to the **Internal ALB DNS**.
4.  **Internal ALB** routes the request to the **Apache Web Servers** in the Private Subnets.
5.  **Apache** serves the default Ubuntu Welcome home page back through the pipeline.

---

## 📁 Repository Structure

```text
├── providers.tf         # AWS Provider configuration
├── variables.tf         # Dynamic input variables & Ubuntu AMI Data Source
├── vpc.tf               # Networking (VPC, Subnets, IGW, NAT GW, Route Tables)
├── security_groups.tf   # Strict Least-Privilege Security Group rules
├── alb_external.tf      # Public Internet-facing Load Balancer
├── alb_internal.tf      # Internal Private Load Balancer
├── ec2_proxy.tf         # Nginx Proxy EC2 instances and target attachments
├── ec2_backend.tf       # Apache Backend EC2 instances and target attachments
├── outputs.tf           # Returns the final External ALB URL
├── nginx_userdata.sh    # User data script to configure Nginx Reverse Proxy
└── apache_userdata.sh   # User data script to install default Apache2
