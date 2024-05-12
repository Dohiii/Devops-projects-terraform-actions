# data "aws_ami" "amazon-2" {
#   most_recent = true

#   filter {
#     name = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-ebs"]
#   }
#   owners = ["amazon"]
# }

# resource "aws_launch_configuration" "wordpress-app-config" {
#   name_prefix     = "wordpress app-"
#   image_id        = data.aws_ami.amazon-2.id
#   instance_type = "t2.micro"
#   security_groups = ["sg-04d517a5b55d3cb19"] #["wordpress-2-sg"]
#   key_name      = "ec2keys"

#    user_data = <<-EOF
#               #!/bin/bash
#               yum install -y httpd
#               echo "Hello from Apache!" > /var/www/html/index.html
#               systemctl start httpd
#               systemctl enable httpd
#               EOF

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "wordpress-app-autoscale" {
#   depends_on = [aws_lb_listener.web_listener, aws_lb.wordpress_lb]
#   name                 = "wordpress-ec2-as-group"
#   min_size             = 1
#   max_size             = 2
#   desired_capacity     = 1
#   launch_configuration = aws_launch_configuration.wordpress-app-config.name
#   vpc_zone_identifier  = ["subnet-02011297bd7572c96", "subnet-0a72b50aa3d0128f2", "subnet-0d9e43161039d1a1f"]

#   target_group_arns = [aws_lb_target_group.web_tg.arn]

#   lifecycle {
#     create_before_destroy = true
#   }
# }


# # Create a new load balancer attachment
# resource "aws_autoscaling_attachment" "example" {
#   autoscaling_group_name = aws_autoscaling_group.wordpress-app-autoscale.id
#   elb                    = aws_lb.wordpress_lb.id
# }