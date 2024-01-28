#GENERAL
region = "ap-south-1"
project = "superops"

#VPC
vpc_cidr_block = "10.0.0.0/20"
private_zone_1_subnet_cidr_block = "10.0.2.0/24"
private_zone_2_subnet_cidr_block = "10.0.3.0/24"
public_subnet_cidr_block = "10.0.1.0/24"
availability_zone = "ap-south-1a"

#VM
server_name = "app"
bastion_ingress_ports = [ {
  key = "SSH"
  value = "22"
  cidr  = "0.0.0.0/0"
} ]
app_ingress_ports = [ {
  key = "SSH"
  value = "22"
  cidr  = "10.1.2.0/24"
},
{
  key ="APP"
  value = "80"
  cidr = "10.1.2.0/24"
} ]