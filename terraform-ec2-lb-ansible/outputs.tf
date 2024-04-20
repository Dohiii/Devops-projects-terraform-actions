output "public_ips" {
  value       = aws_instance.web.*.public_ip
  description = "The public IP addresses of all the web servers."
}

output "load_balancer_dns" {
  value       = aws_lb.web_alb.dns_name
  description = "The DNS name of the load balancer."
}
