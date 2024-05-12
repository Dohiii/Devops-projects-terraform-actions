resource "aws_lb" "wordpress_lb" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-04d517a5b55d3cb19"]
  subnets            = ["subnet-02011297bd7572c96","subnet-0a72b50aa3d0128f2","subnet-0d9e43161039d1a1f"] # Need to be set 
  
  tags = {
    Name = "web-load-balancer"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0e0ca98df725e313c"  
  
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.wordpress_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "web_tg_attach" {
  count            = length(aws_instance.wordpress_app)
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.wordpress_app[count.index].id
  port             = 80
}