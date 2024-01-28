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
  type = list(string)
}

variable "project" {
  description = "Project tag"
  type        = string
}
