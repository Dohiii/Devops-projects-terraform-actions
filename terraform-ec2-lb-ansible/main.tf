provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "instance_count" {
  default = "2"
}

variable "instance_type" {
  default = "t2.micro"
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}

# Load Balancer setup
resource "aws_lb" "web_alb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = ["subnet-089bc376bebd30844", "subnet-0cc7d22b420ddcc10", "subnet-08391f76cb4a8de91"] # Substitute 

  tags = {
    Name = "web-load-balancer"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-098c62601da102b5e"  # Substitute 
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Attach EC2 instances to the target group
resource "aws_lb_target_group_attachment" "web_tg_attach" {
  count           = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id       = aws_instance.web[count.index].id
  port            = 80
}


resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  count                       = var.instance_count
  instance_type               = var.instance_type
  key_name                    = "centralpair"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_web.name]

  tags = {
    Name = "NginxTerraform-${count.index + 1}"
  }
}

output "public_ips" {
  value       = aws_instance.web.*.public_ip
  description = "The public IP addresses of all the web servers."
}

# output "public_dns" {
#   value       = aws_instance.web.*.public_dns
#   description = "The public DNS addresses of all the web servers."
# }

output "load_balancer_dns" {
  value       = aws_lb.web_alb.dns_name
  description = "The DNS name of the load balancer."
}
