# ============================================
# EBS Volumes for Minecraft Server
# ============================================
# These resources are separated from the main infrastructure
# as they may be modified more frequently

# ============================================
# EBS Volume for SMP (Survival Multi Play)
# ============================================
resource "aws_ebs_volume" "smp" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = var.ebs_smp_size
  type              = var.ebs_smp_type
  iops              = var.ebs_smp_iops
  throughput        = var.ebs_smp_throughput
  encrypted         = var.ebs_encryption_enabled

  tags = merge(
    local.tags,
    {
      Name        = "${var.project_name}-smp-ebs"
      ServerType  = "SMP"
      Description = "Survival Multi Play server data"
    }
  )
}

# ============================================
# EBS Volume for Proxy (Velocity)
# ============================================
resource "aws_ebs_volume" "proxy" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = var.ebs_proxy_size
  type              = var.ebs_proxy_type
  iops              = var.ebs_proxy_iops
  throughput        = var.ebs_proxy_throughput
  encrypted         = var.ebs_encryption_enabled

  tags = merge(
    local.tags,
    {
      Name        = "${var.project_name}-proxy-ebs"
      ServerType  = "Proxy"
      Description = "Velocity proxy server data"
    }
  )
}

# ============================================
# Outputs
# ============================================
output "ebs_smp_id" {
  value       = aws_ebs_volume.smp.id
  description = "SMP EBS Volume ID"
}

output "ebs_smp_arn" {
  value       = aws_ebs_volume.smp.arn
  description = "SMP EBS Volume ARN"
}

output "ebs_proxy_id" {
  value       = aws_ebs_volume.proxy.id
  description = "Proxy EBS Volume ID"
}

output "ebs_proxy_arn" {
  value       = aws_ebs_volume.proxy.arn
  description = "Proxy EBS Volume ARN"
}
