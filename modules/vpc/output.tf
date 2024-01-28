output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_zone1_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_zone_1.id
}

output "private_zone2_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_zone_2.id
}

output "nat_ip" {
  description = "EIP of NAT"
  value       = aws_nat_gateway.this.public_ip
}