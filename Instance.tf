resource "aws_instance" "bastion-server" {
  ami                    = var.amiID["ubuntu"] # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "bastion-key"               # Replace with your key pair name

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "nginx-server" {
  ami                    = var.amiID["ubuntu"] # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "nginx-key"                 # Replace with your key pair name

  tags = {
    Name = "nginxHost"
  }
}

resource "aws_instance" "web-server" {
  ami                    = var.amiID["centos"] # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.private_subnet.id # Specify the subnet here
  key_name               = "web-server-key"             # Replace with your key pair name

  tags = {
    Name = "serverHost"
  }
}

resource "aws_instance" "control-server" {
  ami                    = var.amiID["amazon_linux"] # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.control_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "control-server-key"        # Replace with your key pair name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install ansible -y
  EOF

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./keys/control_server_key") # Relative path to your private key for control host
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ec2-user/ansible_project",
      "sudo chown -R ec2-user:ec2-user /home/ec2-user/ansible_project", # copied with user data (root), we need owenership for copying inside
      "sudo chmod -R 755 /home/ec2-user/ansible_project"                # Set read/write/execute permissions
    ]
  }

  provisioner "file" {
    source      = "./ansible_files/"                # Path to your local Ansible project directory
    destination = "/home/ec2-user/ansible_project/" # Destination path on the instance
  }

  tags = {
    Name = "ControlHost"
  }
}

data "template_file" "all_yml" {
  template = file("./ansible_files/group_vars/all.yml.tpl")

  vars = {
    nginx_public_ip           = aws_instance.nginx-server.public_ip
    bastion_private_ip        = aws_instance.bastion-server.private_ip
    webserver_private_ip      = aws_instance.web-server.private_ip
    control_server_private_ip = aws_instance.control-server.private_ip
  }
}

resource "local_file" "ansible_group_vars_all" {
  content  = data.template_file.all_yml.rendered
  filename = "./ansible_files/group_vars/all.yml"
}
