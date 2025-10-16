variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region to deploy resources into"
}

variable "project_name" {
  type        = string
  default     = "mc-infra"
  description = "Project name for resource naming"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Environment name (production, staging, development)"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames in the VPC"
}

variable "vpc_enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support in the VPC"
}

variable "enable_ipv6" {
  type        = bool
  default     = true
  description = "Enable IPv6 CIDR block for VPC"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for public subnet (IPv4)"
}

variable "public_subnet_ipv6_cidr" {
  type        = string
  default     = "00::/64"
  description = "IPv6 CIDR block for public subnet (relative to VPC IPv6)"
}

variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block allowed for SSH access (change to your IP for security)"
}

variable "allowed_ssh_ipv6_cidr" {
  type        = string
  default     = "::/0"
  description = "IPv6 CIDR block allowed for SSH access"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to apply to all resources"
}

# ============================================
# EBS Volume Variables
# ============================================

# SMP (Survival Multi Play) EBS Configuration
variable "ebs_smp_size" {
  type        = number
  default     = 6
  description = "Size of SMP EBS volume in GB"
}

variable "ebs_smp_type" {
  type        = string
  default     = "gp3"
  description = "EBS volume type for SMP (gp3, gp2, io1, io2)"
}

variable "ebs_smp_iops" {
  type        = number
  default     = 3000
  description = "IOPS for SMP EBS volume (gp3: 3000-16000)"
}

variable "ebs_smp_throughput" {
  type        = number
  default     = 125
  description = "Throughput for SMP EBS volume in MB/s (gp3: 125-1000)"
}

# Proxy (Velocity) EBS Configuration
variable "ebs_proxy_size" {
  type        = number
  default     = 2
  description = "Size of Proxy EBS volume in GB"
}

variable "ebs_proxy_type" {
  type        = string
  default     = "gp3"
  description = "EBS volume type for Proxy (gp3, gp2, io1, io2)"
}

variable "ebs_proxy_iops" {
  type        = number
  default     = 3000
  description = "IOPS for Proxy EBS volume (gp3: 3000-16000)"
}

variable "ebs_proxy_throughput" {
  type        = number
  default     = 125
  description = "Throughput for Proxy EBS volume in MB/s (gp3: 125-1000)"
}

# Common EBS Configuration
variable "ebs_encryption_enabled" {
  type        = bool
  default     = true
  description = "Enable encryption for EBS volumes"
}

variable "ebs_deletion_protection" {
  type        = bool
  default     = true
  description = "Enable deletion protection for EBS volumes (prevent_destroy)"
}

