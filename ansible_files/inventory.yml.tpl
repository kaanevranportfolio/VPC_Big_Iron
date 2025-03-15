all:
  vars:
    ansible_python_interpreter: /usr/bin/python3

  children:
    bastion:
      hosts:
        bastion:
          ansible_host: ${bastion_private_ip}
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ./keys/bastion_key

    nginx:
      hosts:
        nginx:
          ansible_host: ${nginx_public_ip}
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ./keys/nginx_key

    webservers:
      hosts:
        webserver:
          ansible_host: ${webserver_private_ip}
          ansible_user: ec2-user
          ansible_ssh_private_key_file: ./keys/web_server_key
          ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q ubuntu@${bastion_private_ip} -o StrictHostKeyChecking=no -i ./keys/bastion_key"'
