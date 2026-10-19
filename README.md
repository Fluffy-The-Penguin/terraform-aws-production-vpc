# Production-Grade Multi-AZ AWS VPC & Security Architecture

![Terraform](https://img.shields.io/badge/Terraform-v1.10+-623CE4?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-ap--south--1-232F3E?style=flat&logo=amazon-aws&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Multi--AZ%20High%20Availability-success)
![IaC](https://img.shields.io/badge/IaC-Declarative-blue)

A modular, enterprise-grade Infrastructure as Code (IaC) repository provisioned with **Terraform** on **Amazon Web Services (AWS)**. 

Designed for **High Availability (HA)** across two Availability Zones (`ap-south-1a` and `ap-south-1b`), implementing a strict two-tier Public/Private subnet topology, cryptographic **Security Group Chaining**, and modern **S3 Remote State Storage with Native State Locking**.

---

## 🧭 Architectural Topology

```mermaid
flowchart TD
    subgraph VPC ["AWS VPC: 10.0.0.0/16 (Mumbai: ap-south-1)"]
        IGW["🚪 Internet Gateway (0.0.0.0/0)"]

        subgraph AZ1 ["Availability Zone 1 (ap-south-1a)"]
            PUB1["🌐 Public Subnet 1 (10.0.1.0/24)<br/>• MapPublicIP: True<br/>• Hosts: Load Balancers (ALB)"]
            PRIV1["🔒 Private Subnet 1 (10.0.11.0/24)<br/>• MapPublicIP: False<br/>• Hosts: Backend / Database Replica"]
        end

        subgraph AZ2 ["Availability Zone 2 (ap-south-1b)"]
            PUB2["🌐 Public Subnet 2 (10.0.2.0/24)<br/>• MapPublicIP: True<br/>• Hosts: Load Balancers (ALB)"]
            PRIV2["🔒 Private Subnet 2 (10.0.12.0/24)<br/>• MapPublicIP: False<br/>• Hosts: Backend / Database Primary"]
        end

        RT_PUB["Public Route Table<br/>(0.0.0.0/0 -> IGW)"]
        RT_PRIV["Private Route Table<br/>(Local VPC Only)"]

        IGW --> RT_PUB
        RT_PUB --> PUB1
        RT_PUB --> PUB2

        RT_PRIV --> PRIV1
        RT_PRIV --> PRIV2
    end

    subgraph SEC ["Security Group Chaining Architecture"]
        WEB_SG["👮 Web Security Group (web-sg)<br/>• Ingress: Port 80 & 443 from 0.0.0.0/0"]
        DB_SG["🔒 Database Security Group (db-sg)<br/>• Ingress: Port 5432 from web-sg ONLY!"]
        HACKER["❌ Public Internet / Attackers"]

        WEB_SG -- "Allows Port 5432 (VIP Badge)" --> DB_SG
        HACKER -. "Blocked from direct DB access" .-x DB_SG
    end
```

---

## 🎯 Key Architectural Pillars

### 1. High Availability (Multi-AZ)
* Redundancy across two physically isolated AWS data centers (`ap-south-1a` and `ap-south-1b`) ensures resilience against single-facility power or network failures.
* Minimum standard required by AWS Application Load Balancers (ALBs) and Multi-AZ Amazon RDS failover groups.

### 2. Strict Subnet Isolation
* **Public Tier (`10.0.1.0/24`, `10.0.2.0/24`):** Associated with an Internet Gateway (`IGW`) route for public-facing ingress.
* **Private Tier (`10.0.11.0/24`, `10.0.12.0/24`):** Completely decoupled from the IGW. Databases and internal compute run in total network isolation.

### 3. Cryptographic Security Group Chaining
* Eliminates brittle, hardcoded IP whitelisting in firewalls.
* Database Security Group (`db_sg`) strictly permits incoming TCP on port `5432` originating **only** from network interfaces associated with `web_sg` (`security_groups = [aws_security_group.web_sg.id]`).

### 4. Production Remote Backend (S3 + Native Lockfile)
* Remote state storage hosted in an Amazon S3 bucket with **S3 Versioning** (snapshot rollbacks) and **AES-256 server-side encryption**.
* Uses modern Terraform v1.10+ native S3 conditional write locking (`use_lockfile = true`), completely eliminating team race conditions and state corruption.

---

## 📁 Repository Structure

```text
├── providers.tf            # Terraform & AWS provider definitions, S3 backend configuration, and default tags
├── variables.tf            # Parameterized input variables (CIDRs, region, project tags)
├── terraform.tfvars.example # Example variable values for staging and production deployments
├── vpc.tf                  # Declarative VPC, Subnets (count loops), IGW, and Route Tables
├── security.tf             # Web and Database Security Groups with chained ingress rules
├── outputs.tf              # Exported attributes (VPC ID, Subnet IDs, Security Group IDs)
└── .gitignore              # Ignores local state, backups, and provider cache
```

---

## 🚀 Quickstart & Deployment

### Prerequisites
* [AWS CLI v2](https://aws.amazon.com/cli/) configured with appropriate IAM credentials.
* [Terraform v1.5+](https://developer.hashicorp.com/terraform/downloads).

### 1. Initialize & Download Providers
```bash
terraform init
```

### 2. Preview Execution Plan
```bash
terraform plan
```

### 3. Deploy to AWS
```bash
terraform apply
```

### 4. Inspect Outputs
```bash
terraform output vpc_id
terraform output public_subnet_ids
terraform output private_subnet_ids
```

### 5. Clean Teardown
```bash
terraform destroy
```

---

## 👨‍💻 Author
**Aryan**  
* GitHub: [@Fluffy-The-Penguin](https://github.com/Fluffy-The-Penguin)
