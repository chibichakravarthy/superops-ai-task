variable "vpc_id" {
  description = "The ID of the VPC where VM will reside"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet where the VM will be deployed."
  type        = string
}

variable "ami_id" {
  description = "AMI ID of the EC2 machine"
  type = string
  default = "ami-03f4878755434977f"
}

variable "instance_type" {
  description = "The type of the instance to create for the VM"
  type        = string
  default     = "t2.micro"
}

variable "server_name" {
  description = "Name of the server to deploy"
  type = string
}

# variable "route53_zone_id" {
#   description = "The ID of the Route53 zone to create records in."
#   type        = string
# }

variable "project" {
  description = "Project tag"
  type        = string
}

variable "secgroup_id" {
  description = "Security group ID of another Security group"
  type = list(string)
}

variable "associate_public_ip_address" {
  description = "Assign a public IP"
  type = bool
}

# variable "allocated_storage" {
#   description = "The size of the drive in gigabytes"
#   type        = number
#   default     = 20
# }

variable "port" {
  description = "The port to allow in Security Group"
  type        = list(map(string))
}

#user script to run when a ec2 machine is created

locals {
  mysql_install = <<EOF
#!/bin/bash

# Adding Docker's offical GPG key
apt-get update -y
apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y

# Install the Docker packages
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#Configure to start docker on boot
systemctl enable docker
systemctl start docker

# Deploy docker compose
cd /home/ubuntu
while true; do
    if systemctl is-active --quiet docker.service; then
        echo "Docker is running."
        docker run -d --rm --name web-test -p 80:8000 crccheck/hello-world
        break
    else
        echo "Docker is not running."
    fi
    sleep 1
done
EOF
}