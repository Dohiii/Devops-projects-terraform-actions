output "public_ips1" {
    value       = aws_instance.wordpress_app.*.public_ip
    description = "The public IP addresses of all the web servers."
  }
  
  output "load_balancer_dns" {
    value       = aws_lb.wordpress_lb.dns_name
    description = "The DNS name of the load balancer."
  }