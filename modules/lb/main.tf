resource "aws_security_group" "this" {
  name        = "${var.project}-lb-secgroup"
  description = "Traffic rules"
  vpc_id      = var.vpc_id

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


resource "aws_lb" "this" {
  name               = "${var.project}-vpc"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  enable_deletion_protection = false

  subnets = var.subnet_ids

  enable_cross_zone_load_balancing = true

  enable_http2 = true

  idle_timeout = 60
}


resource "aws_lb_target_group" "this" {
  name     = "${var.project}-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id
}

# locals {
#   instance_tags = { for instance in var.instance_ids : instance => instance.tags }
# }

resource "aws_lb_target_group_attachment" "this" {
  for_each = { for idx, id in var.instance_ids : idx => id }
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}