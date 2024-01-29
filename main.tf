module "vpc" {
  source                    = "./modules/vpc"
  vpc_cidr_block            = var.vpc_cidr_block
  public_zone_1_subnet_cidr_block = var.public_zone_1_subnet_cidr_block
  public_zone_2_subnet_cidr_block  = var.public_zone_2_subnet_cidr_block
  private_zone_1_subnet_cidr_block = var.private_zone_1_subnet_cidr_block
  private_zone_2_subnet_cidr_block = var.private_zone_2_subnet_cidr_block
  availability_zone         = ["ap-south-1a","ap-south-1b"]
  project                   = var.project
}

module "bastion" {
  source      = "./modules/vm"
  server_name = "bastion"
  port        = var.bastion_ingress_ports
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_zone_1_subnet_id
  secgroup_id = []
  associate_public_ip_address = true
  project     = var.project
}

resource "aws_security_group" "lb_sec_group" {
  name        = "${var.project}-lb-secgroup"
  description = "Traffic rules"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


module "app1" {
  source      = "./modules/vm"
  server_name = "app1"
  port        = var.app_ingress_ports
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.private_zone1_subnet_id
  secgroup_id = ["${aws_security_group.lb_sec_group.id}"]
  associate_public_ip_address = false
  project     = var.project
}

module "app2" {
  source      = "./modules/vm"
  server_name = "app2"
  port        = var.app_ingress_ports
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.private_zone2_subnet_id
  secgroup_id = ["${aws_security_group.lb_sec_group.id}"]
  associate_public_ip_address = false
  project     = var.project
}

module "lb" {
    source = "./modules/lb"
    project     = var.project
    vpc_id = module.vpc.vpc_id
    instance_ids  = ["${module.app1.vm_id}","${module.app2.vm_id}"]
    subnet_ids = ["${module.vpc.public_zone_1_subnet_id}","${module.vpc.public_zone_2_subnet_id}"]
    secgroup_ids = ["${aws_security_group.lb_sec_group.id}"]
}