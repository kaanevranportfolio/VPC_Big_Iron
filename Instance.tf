resource "aws_instance" "bastion-server" {
  ami                    = var.amiID # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "bastion-key"               # Replace with your key pair name

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "nginx-server" {
  ami                    = var.amiID # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "nginx-key"                 # Replace with your key pair name

  tags = {
    Name = "nginxHost"
  }
}

resource "aws_instance" "web-server" {
  ami                    = var.amiID # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.private_subnet.id # Specify the subnet here
  key_name               = "server-key"                 # Replace with your key pair name

  tags = {
    Name = "serverHost"
  }
}


