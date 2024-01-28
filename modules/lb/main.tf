resource "aws_lb" "this" {
  name               = "${var.project}-vpc"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.secgroup_ids
  enable_deletion_protection = false

  subnets = var.subnet_ids

  enable_cross_zone_load_balancing = true

  enable_http2 = true

  idle_timeout = 60
  access_logs {
    bucket  = "superops-tfstate"
    prefix  = "lblogs"
    enabled = true
  }
}


resource "aws_lb_target_group" "this" {
  name     = "${var.project}-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = toset(var.instance_ids)
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