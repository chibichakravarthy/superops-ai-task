# GENERAL - START

variable "region" {
  description = "Region to create the infrastructure"
  type        = string
}

variable "project" {
  description = "Name of the project that is created. It is also used in all the tags and resource naming"
  type        = string
}

# GENERAL - END

# VPC - START
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_zone_1_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_zone_2_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_zone_1_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "private_zone_2_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Zone to create the VPC and Subnets"
  type = string
}
# VPC - END

# VM - START
variable "instance_type" {
  description = "The type of the instance to create for the VM"
  type        = string
  default     = "t2.micro"
}

variable "server_name" {
  description = "Name of the server to deploy"
  type = string
}

variable "bastion_ingress_ports" {
  description = "List of port to allow in Bastion Machine"
  type = list(map(string))
}

variable "app_ingress_ports" {
  description = "List of port to allow in App Machine"
  type = list(map(string))
}
# VM - START