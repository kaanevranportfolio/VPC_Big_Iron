resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("./keys/bastion_key.pub") # Path to your public key file
}

resource "aws_key_pair" "nginx_key" {
  key_name   = "nginx-key"
  public_key = file("./keys/nginx_key.pub") # Path to your public key file
}

resource "aws_key_pair" "control_server_key" {
  key_name   = "control-server-key"
  public_key = file("./keys/control_server_key.pub") # Path to your public key file
}

resource "aws_key_pair" "web_server_key" {
  key_name   = "web-server-key"
  public_key = file("./keys/web_server_key.pub") # Path to your public key file
}