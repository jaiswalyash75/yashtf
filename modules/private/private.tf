resource "aws_security_group" "server_private" {
  name        = "yash-server-private-sg"
  description = "Allow incoming connections."
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id

  tags = {
    Name = "yash-server-private-sg"
  }
}



data "template_file" "init" {
  template = file("./modules/vpc/start.sh.tpl")

  vars = {
    address = var.address
  }
}



resource "aws_instance" "web2" {
  ami                         = var.ami
  availability_zone           = var.az1
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.server_private.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  source_dest_check           = false
  user_data                   = data.template_file.init.rendered
  tags = {
    Name = "yash-server-2-private"
  }
  depends_on = [aws_security_group.server_private]
}
