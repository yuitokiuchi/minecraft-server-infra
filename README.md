# Minecraft Server Infrastructure

AWS infrastructure for running Minecraft servers on EC2 with Terraform.

## What's Included

- VPC with IPv4 + IPv6 support
- Public subnet
- Internet Gateway
- Security Group (SSH + Minecraft ports)

## Quick Start

```bash
# Setup
cp terraform.tfvars.example terraform.tfvars

# Deploy
terraform init
terraform plan
terraform apply

# Destroy
terraform destroy
```

## Configuration

Edit `terraform.tfvars` to customize:

| Variable | Default | Purpose |
|----------|---------|---------|
| `region` | `ap-northeast-1` | AWS region |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `allowed_ssh_cidr` | `0.0.0.0/0` | SSH access (change to your IP) |
| `enable_ipv6` | `true` | Enable IPv6 |

## Security

⚠️ **Important**: Update `allowed_ssh_cidr` to your IP address:

```hcl
allowed_ssh_cidr = "203.0.113.0/32"
```

## Outputs

After deployment, you'll get:

- VPC ID
- Subnet ID
- Security Group ID
- Internet Gateway ID