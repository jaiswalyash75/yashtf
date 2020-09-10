resource "aws_security_group" "server" {
  name        = "yash-server-sg"
  description = "Allow incoming connections."
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id

  tags = {
    Name = "yash-server-sg"
  }
}


resource "aws_instance" "web1" {
  ami                         = var.ami
  availability_zone           = var.az
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.server.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "yash-server-1-public"
  }
  depends_on = [aws_security_group.server]
}