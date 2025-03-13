# Webserver Role Documentation

This directory contains the Ansible role for configuring a web server. The web server role is designed to automate the installation and configuration of a web server on target hosts.

## Role Variables

The following variables can be defined in `vars/main.yml` or overridden in your playbook:

- `webserver_port`: The port on which the web server will listen (default: 80).
- `webserver_document_root`: The directory where the web server will serve files from (default: /var/www/html).

## Dependencies

This role does not have any dependencies on other roles.

## Example Playbook

Here is an example of how to use this role in a playbook:

```yaml
- hosts: webservers
  roles:
    - webserver
```

## License

This role is licensed under the MIT License.

## Author Information

This role was created in 2023 by [Your Name].