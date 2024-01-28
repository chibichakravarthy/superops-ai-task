# VPC Output - START
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_zone1_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_zone_1_subnet_id
}

output "public_zone2_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_zone_2_subnet_id
}

output "private_zone1_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_zone1_subnet_id
}

output "private_zone2_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_zone2_subnet_id
}
# VPC Output - END

# VM Output- START
output "bastion_ip" {
  description = "Public IP of the VM"
  value = module.bastion.vm_ip
}

output "app1_ip" {
  description = "Public IP of the VM"
  value = module.app1.vm_ip
}