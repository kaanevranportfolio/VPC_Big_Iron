resource "aws_instance" "bastion-server" {
  ami                    = var.amiID["ubuntu"] # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "bastion-key"               # Replace with your key pair name


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./keys/bastion_key") # Relative path to your private key for bastion host
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "./keys/web_server_key"            # Path to your local web server private key
    destination = "/home/ubuntu/.ssh/web_server_key" # Destination path on the instance
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 /home/ubuntu/.ssh/web_server_key"
    ]
  }

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

resource "aws_iam_instance_profile" "control_server_profile" {
  name = "big-iron-ansible-instance-profile"

  role = "big-iron-ansible-role"
}

resource "aws_instance" "control-server" {
  ami                    = var.amiID["amazon_linux"] # Replace with your preferred AMI ID
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.control_sg.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet here
  key_name               = "control-server-key"        # Replace with your key pair name
  iam_instance_profile   = aws_iam_instance_profile.control_server_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install ansible -y
  EOF

  tags = {
    Name = "ControlHost"
  }
}




data "template_file" "inventory_ini" {
  template = file("./ansible_files/inventory.yml.tpl")

  vars = {
    nginx_public_ip           = aws_instance.nginx-server.public_ip
    bastion_private_ip        = aws_instance.bastion-server.private_ip
    webserver_private_ip      = aws_instance.web-server.private_ip
    control_server_private_ip = aws_instance.control-server.private_ip
  }
}

data "template_file" "all_yml" {
  template = file("./ansible_files/group_vars/all.yml.tpl")

  vars = {
    nginx_public_ip           = aws_instance.nginx-server.public_ip
    bastion_private_ip        = aws_instance.bastion-server.private_ip
    webserver_private_ip      = aws_instance.web-server.private_ip
    control_server_private_ip = aws_instance.control-server.private_ip
    control_server_public_ip  = aws_instance.control-server.public_ip
  }
}


resource "local_file" "ansible_inventory_ini" {
  depends_on = [
    aws_instance.control-server,
    aws_instance.bastion-server,
    aws_instance.nginx-server,
    aws_instance.web-server
  ]
  content  = data.template_file.inventory_ini.rendered
  filename = "./ansible_files/inventory.yml"
}

resource "local_file" "ansible_group_vars_all" {
  depends_on = [
    aws_instance.control-server,
    aws_instance.bastion-server,
    aws_instance.nginx-server,
    aws_instance.web-server
  ]
  content  = data.template_file.all_yml.rendered
  filename = "./ansible_files/group_vars/all.yml"
}

resource "null_resource" "provision_control_server" {
  depends_on = [
    local_file.ansible_inventory_ini,
    local_file.ansible_group_vars_all
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./keys/control_server_key")
    host        = aws_instance.control-server.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ec2-user/ansible_files"
    ]
  }

  provisioner "file" {
    source      = "./ansible_files/"
    destination = "/home/ec2-user/ansible_files/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/ec2-user/ansible_files/",
      "sudo chmod 600 /home/ec2-user/ansible_files/keys/*"
    ]
  }
}