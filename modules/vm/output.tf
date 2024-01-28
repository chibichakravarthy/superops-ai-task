output "vm_ip" {
  description = "Public IP of the VM"
  value = aws_instance.this.public_ip
}

output "vm_id" {
  description = "ID of the created VM"
  value = aws_instance.this.id
}

output "security_group_id" {
  description = "Security Group ID of the VM"
  value = aws_security_group.this.id
}