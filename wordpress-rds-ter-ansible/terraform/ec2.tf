variable "azs" {
  description = "List of availability zones to deploy instances"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}



resource "aws_instance" "wordpress_app" {
  count         = length(var.azs)  # Creates an instance in each AZ
  ami           = "ami-0a946522147cbcbcc"
  instance_type = "t2.micro"
  key_name      = "ec2keys"
  availability_zone = var.azs[count.index]
#   user_data     = <<-EOF
#                   #!/bin/bash
#                   yum install -y httpd
#                   echo "Hello from Apache!" > /var/www/html/index.html
#                   systemctl start httpd
#                   EOF
  security_groups = ["wordpress-2-sg"]

  tags = {
    Name = "wordpress app ${count.index + 1}"  # Unique name for each instance
  }
}




# only needed one time, this group will be asociated with defaut group so it will be impossible or hard to delete it and recreate after from terraform

# resource "aws_security_group" "wordpress_sg" {
#   name        = "wordpress-2-sg"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
