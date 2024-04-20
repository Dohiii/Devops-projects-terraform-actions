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
