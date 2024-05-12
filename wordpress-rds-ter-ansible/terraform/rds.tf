resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  max_allocated_storage = 1000
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"  # Use appropriate MySQL version
  instance_class       = "db.t3.micro"
  db_name              = "wordpress"
  identifier           = "wordpress"
  username             = "valadmin" #set username
  password             = "Master1Password33" # set password
  publicly_accessible  = false
  skip_final_snapshot  = "true"
}


# resource "aws_security_group_rule" "allow_mysql" {
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   security_group_id = aws_security_group.wordpress_sg.id
#   source_security_group_id = aws_security_group.wordpress_sg.id
# }