data "aws_vpc" "selected" {
  id = var.vpc_id
}

# SecGroups - START

resource "aws_security_group" "this" {
  name        = "${var.project}-${var.server_name}-secgroup"
  description = "Traffic rules"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.port
    content {
      description = "Allow ${ingress.value["key"]} port"
      from_port   = ingress.value["value"]
      to_port     = ingress.value["value"]
      protocol    = "tcp"
      cidr_blocks = [ingress.value["cidr"]]
      security_groups = var.secgroup_id == "" ? null : var.secgroup_id
    }
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

#SecGroups - END

#Keys - START

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project}-${var.server_name}-kp"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.this.private_key_pem
  filename = "secrets/${var.project}-${var.server_name}-kp.pem"
}

#Keys - END

#EC2 - START

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = aws_key_pair.this.key_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data = local.mysql_install
  tags = {
    Name        = "${var.project}-${var.server_name}-ec2"
    Project     = var.project
  }
}

#EC2 - END