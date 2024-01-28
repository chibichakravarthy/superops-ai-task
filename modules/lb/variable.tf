variable "secgroup_ids" {
  description = "Security group ID of another Security group"
  type = list(string)
}

variable "project" {
  description = "Project tag"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet group IDs to target"
  type = list(string)
}

variable "instance_ids" {
  description = "Instances to add to LB"
  type = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where LB will reside"
  type        = string
}