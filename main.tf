provider "aws" {
  region = var.region
}

# ============================================
# Common tag setup
# ============================================
locals {
  tags = merge(
    var.common_tags,
    {
      CreatedBy = "Terraform"
      CreatedAt = timestamp()
    }
  )
}

# 動作確認用
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

# ============================================
# VPC
# ============================================
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

# ============================================
# Internet Gateway
# ============================================
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}

# ============================================
# Public Subnet (IPv4 + IPv6)
# ============================================
resource "aws_subnet" "public" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_cidr
  availability_zone               = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.enable_ipv6
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1) : null

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-public-subnet"
      Type = "Public"
    }
  )

  depends_on = [aws_vpc.main]
}

# ============================================
# Route Table for Public Subnet
# ============================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-public-rt"
      Type = "Public"
    }
  )
}

# IPv4 Route
resource "aws_route" "public_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# IPv6 Route (if enabled)
resource "aws_route" "public_ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ============================================
# Security Group for EC2
# ============================================
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for EC2 instances - Allow SSH and Application Port"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-ec2-sg"
    }
  )
}

# Ingress rule for SSH (port 22) - IPv4
resource "aws_vpc_security_group_ingress_rule" "ssh_ipv4" {
  security_group_id = aws_security_group.ec2.id

  description = "SSH access (IPv4)"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = var.allowed_ssh_cidr

  tags = merge(
    local.tags,
    {
      Name = "allow-ssh-ipv4"
    }
  )
}

# Ingress rule for SSH (port 22) - IPv6
resource "aws_vpc_security_group_ingress_rule" "ssh_ipv6" {
  count             = var.enable_ipv6 ? 1 : 0
  security_group_id = aws_security_group.ec2.id

  description = "SSH access (IPv6)"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv6   = var.allowed_ssh_ipv6_cidr

  tags = merge(
    local.tags,
    {
      Name = "allow-ssh-ipv6"
    }
  )
}

# Ingress rule for Application Port (port 25565) - TCP IPv4
resource "aws_vpc_security_group_ingress_rule" "app_port_tcp_ipv4" {
  security_group_id = aws_security_group.ec2.id

  description = "Application port TCP access (IPv4) - e.g., Minecraft"
  from_port   = 25565
  to_port     = 25565
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(
    local.tags,
    {
      Name = "allow-app-port-tcp-ipv4"
    }
  )
}

# Ingress rule for Application Port (port 25565) - TCP IPv6
resource "aws_vpc_security_group_ingress_rule" "app_port_tcp_ipv6" {
  count             = var.enable_ipv6 ? 1 : 0
  security_group_id = aws_security_group.ec2.id

  description = "Application port TCP access (IPv6) - e.g., Minecraft"
  from_port   = 25565
  to_port     = 25565
  ip_protocol = "tcp"
  cidr_ipv6   = "::/0"

  tags = merge(
    local.tags,
    {
      Name = "allow-app-port-tcp-ipv6"
    }
  )
}

# Ingress rule for Application Port (port 25565) - UDP IPv4
resource "aws_vpc_security_group_ingress_rule" "app_port_udp_ipv4" {
  security_group_id = aws_security_group.ec2.id

  description = "Application port UDP access (IPv4) - e.g., Minecraft query protocol"
  from_port   = 25565
  to_port     = 25565
  ip_protocol = "udp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(
    local.tags,
    {
      Name = "allow-app-port-udp-ipv4"
    }
  )
}

# Ingress rule for Application Port (port 25565) - UDP IPv6
resource "aws_vpc_security_group_ingress_rule" "app_port_udp_ipv6" {
  count             = var.enable_ipv6 ? 1 : 0
  security_group_id = aws_security_group.ec2.id

  description = "Application port UDP access (IPv6) - e.g., Minecraft query protocol"
  from_port   = 25565
  to_port     = 25565
  ip_protocol = "udp"
  cidr_ipv6   = "::/0"

  tags = merge(
    local.tags,
    {
      Name = "allow-app-port-udp-ipv6"
    }
  )
}

# Egress rule (allow all outbound traffic) - IPv4
resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.ec2.id

  description = "Allow all outbound traffic (IPv4)"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(
    local.tags,
    {
      Name = "allow-all-outbound-ipv4"
    }
  )
}

# Egress rule (allow all outbound traffic) - IPv6
resource "aws_vpc_security_group_egress_rule" "all_ipv6" {
  count             = var.enable_ipv6 ? 1 : 0
  security_group_id = aws_security_group.ec2.id

  description = "Allow all outbound traffic (IPv6)"
  ip_protocol = "-1"
  cidr_ipv6   = "::/0"

  tags = merge(
    local.tags,
    {
      Name = "allow-all-outbound-ipv6"
    }
  )
}

# ============================================
# Outputs
# ============================================
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "vpc_ipv6_cidr" {
  value       = var.enable_ipv6 ? aws_vpc.main.ipv6_cidr_block : null
  description = "VPC IPv6 CIDR block"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "Public Subnet ID"
}

output "public_subnet_ipv4_cidr" {
  value       = aws_subnet.public.cidr_block
  description = "Public Subnet IPv4 CIDR block"
}

output "public_subnet_ipv6_cidr" {
  value       = var.enable_ipv6 ? aws_subnet.public.ipv6_cidr_block : null
  description = "Public Subnet IPv6 CIDR block"
}

output "security_group_id" {
  value       = aws_security_group.ec2.id
  description = "EC2 Security Group ID"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "Internet Gateway ID"
}

output "route_table_id" {
  value       = aws_route_table.public.id
  description = "Public Route Table ID"
}