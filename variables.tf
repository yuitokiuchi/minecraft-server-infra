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