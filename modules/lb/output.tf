output "lb_dns" {
  description = "Domain for the LB"
  value = aws_lb.this.dns_name
}